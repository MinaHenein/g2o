#include <Eigen/StdVector>
#include <Eigen/Geometry>
#include <iostream>
#include <stdint.h>
#include <fstream>
#include <string>
#include <iterator>

#include "g2o/core/sparse_optimizer.h"
#include "g2o/core/sparse_optimizer_terminate_action.h"
#include "g2o/core/robust_kernel_impl.h"
#include "g2o/core/block_solver.h"
#include "g2o/core/solver.h"
#include "g2o/core/optimization_algorithm_levenberg.h"
#include "g2o/core/optimization_algorithm_dogleg.h"
#include "g2o/solvers/cholmod/linear_solver_cholmod.h"
#include "g2o/solvers/dense/linear_solver_dense.h"
#include "g2o/solvers/csparse/linear_solver_csparse.h"
#include "g2o/types/sba/types_six_dof_expmap.h"
#include "g2o/types/slam3d/types_slam3d.h"

using namespace Eigen;
using namespace std;
using namespace g2o;

int main(){

    int ROBUST_KERNEL = 1;
    ifstream file_meas("/home/mina/data/mina/workspace/src/Git/g2o/g2o/examples/dynamic_slam_graph/Data/GraphFiles/kitti-0003-0-40_Meas.graph");
    ifstream file_gt("/home/mina/data/mina/workspace/src/Git/g2o/g2o/examples/dynamic_slam_graph/Data/GraphFiles/kitti-0003-0-40_GT.graph");
    ifstream file_init("/home/mina/data/mina/workspace/src/Git/g2o/g2o/examples/dynamic_slam_graph/Data/GraphFiles/kitti-0003-0-40_initialisation.graph");

    vector<g2o::SE3Quat> odom_measurements;
    vector<MatrixXd> odom_measurements_information;
    vector<Vector2d> odom_measurements_vertices;
    vector<Vector3d> point_measurements;
    vector<Matrix3d> point_measurements_information;
    vector<Vector2d> point_measurements_vertices;
    vector<Vector3d> data_associations_vertices;

    string line_meas;
    while (getline(file_meas, line_meas)) {
        if (line_meas.find("EDGE_R3_SO3") != string::npos) {
            istringstream iss(line_meas);
            vector<string> result{istream_iterator<string>(iss), {}};
            Vector3d axisAngle_odom(stod(result[6]),stod(result[7]),stod(result[8]));
            Vector3d axis_odom = axisAngle_odom/axisAngle_odom.norm();
            Matrix3d R_odom;
            if (axisAngle_odom.norm()==0) R_odom = Matrix3d::Identity();
            else R_odom = AngleAxisd(axisAngle_odom.norm(), axis_odom);
            Matrix<double,3,1> t_odom = Vector3(stod(result[3]),stod(result[4]),stod(result[5]));;
            odom_measurements.push_back(g2o::SE3Quat(R_odom,t_odom));
            odom_measurements_vertices.push_back(Vector2d(stoi(result[1]),stoi(result[2])));
            Matrix<double,6,6> covariance_odom;
            covariance_odom << stod(result[9]),0,0,0,0,0,0,stod(result[15]),0,0,0,0,0,0,stod(result[20]),0,0,0,0,0,0,
            stod(result[24]),0,0,0,0,0,0,stod(result[27]),0,0,0,0,0,0,stod(result[29]);
            odom_measurements_information.push_back(covariance_odom.inverse());
        }
        if (line_meas.find("EDGE_3D") != string::npos) {
            istringstream iss(line_meas);
            vector<string> result{istream_iterator<string>(iss), {}};
            point_measurements.push_back(Vector3d(stod(result[3]),stod(result[4]),stod(result[5])));
            point_measurements_vertices.push_back(Vector2d(stoi(result[1]),stoi(result[2])));
            Matrix<double,3,3> covariance_point_measurement;
            covariance_point_measurement << stod(result[6]),0,0,0,stod(result[9]),0,0,0,stod(result[11]);
            point_measurements_information.push_back(covariance_point_measurement.inverse());
        }
        if (line_meas.find("2PointsDataAssociation") != string::npos) {
            istringstream iss(line_meas);
            vector<string> result{istream_iterator<string>(iss), {}};
            data_associations_vertices.push_back(Vector3d(stoi(result[1]),stoi(result[2]),stoi(result[3])));
        }
    }
    file_meas.close();

    vector<g2o::SE3Quat> gt_camera_poses;
    vector<int> camera_vertices;
    vector<Vector3d> gt_point_positions;
    vector<int> point_vertices;
    vector<g2o::SE3Quat> gt_object_motions;
    vector<int> motion_vertices;

    string line_gt;
    while (getline(file_gt, line_gt)) {
        if (line_gt.find("VERTEX_POSE_R3_SO3") != string::npos) {
            istringstream iss(line_gt);
            vector<string> result{istream_iterator<string>(iss), {}};
            Vector3d axisAngle_pose(stod(result[5]),stod(result[6]),stod(result[7]));
            Vector3d axis_pose = axisAngle_pose/axisAngle_pose.norm();
            Matrix3d R_pose;
            if (axisAngle_pose.norm()==0) R_pose = Matrix3d::Identity();
            else R_pose = AngleAxisd(axisAngle_pose.norm(), axis_pose);
            Matrix<double,3,1> t_pose = Vector3(stod(result[2]),stod(result[3]),stod(result[4]));;
            gt_camera_poses.push_back(g2o::SE3Quat(R_pose,t_pose));
            camera_vertices.push_back(stoi(result[1]));
        }
        if (line_gt.find("VERTEX_POINT_3D") != string::npos) {
            istringstream iss(line_gt);
            vector<string> result{istream_iterator<string>(iss), {}};
            gt_point_positions.push_back(Vector3d(stod(result[2]),stod(result[3]),stod(result[4])));
            point_vertices.push_back(stoi(result[1]));
        }
        if (line_gt.find("VERTEX_SE3Motion") != string::npos) {
            istringstream iss(line_gt);
            vector<string> result{istream_iterator<string>(iss), {}};
            Vector3d axisAngle_motion(stod(result[5]),stod(result[6]),stod(result[7]));
            Vector3d axis_motion = axisAngle_motion/axisAngle_motion.norm();
            Matrix3d R_motion;
            if (axisAngle_motion.norm()==0) R_motion = Matrix3d::Identity();
            else R_motion = AngleAxisd(axisAngle_motion.norm(), axis_motion);
            Matrix<double,3,1> t_motion = Vector3(stod(result[2]),stod(result[3]),stod(result[4]));;
            gt_object_motions.push_back(g2o::SE3Quat(R_motion,t_motion));
            motion_vertices.push_back(stoi(result[1]));
        }
    }
    file_gt.close();


    vector<g2o::SE3Quat> init_camera_poses;
    vector<Vector3d> init_point_positions;
    vector<g2o::SE3Quat> init_object_motions;

    string line_init;
    while (getline(file_init, line_init)) {
        if (line_init.find("VERTEX_POSE_R3_SO3") != string::npos) {
            istringstream iss(line_init);
            vector<string> result{istream_iterator<string>(iss), {}};
            Vector3d axisAngle_pose_init(stod(result[5]),stod(result[6]),stod(result[7]));
            Vector3d axis_pose_init = axisAngle_pose_init/axisAngle_pose_init.norm();
            Matrix3d R_pose_init;
            if (axisAngle_pose_init.norm()==0) R_pose_init = Matrix3d::Identity();
            else R_pose_init = AngleAxisd(axisAngle_pose_init.norm(), axis_pose_init);
            Matrix<double,3,1> t_pose_init = Vector3(stod(result[2]),stod(result[3]),stod(result[4]));;
            init_camera_poses.push_back(g2o::SE3Quat(R_pose_init,t_pose_init));
        }
        if (line_init.find("VERTEX_POINT_3D") != string::npos) {
            istringstream iss(line_init);
            vector<string> result{istream_iterator<string>(iss), {}};
            init_point_positions.push_back(Vector3d(stod(result[2]),stod(result[3]),stod(result[4])));
        }
        if (line_init.find("VERTEX_SE3Motion") != string::npos) {
            istringstream iss(line_init);
            vector<string> result{istream_iterator<string>(iss), {}};
            Vector3d axisAngle_motion_init(stod(result[5]),stod(result[6]),stod(result[7]));
            Vector3d axis_motion_init = axisAngle_motion_init/axisAngle_motion_init.norm();
            Matrix3d R_motion_init;
            if (axisAngle_motion_init.norm()==0) R_motion_init = Matrix3d::Identity();
            else R_motion_init = AngleAxisd(axisAngle_motion_init.norm(), axis_motion_init);
            Matrix<double,3,1> t_motion_init = Vector3(stod(result[2]),stod(result[3]),stod(result[4]));;
            init_object_motions.push_back(g2o::SE3Quat(R_motion_init,t_motion_init));
        }
    }
    file_init.close();


    SparseOptimizer optimizer;
    optimizer.setVerbose(true);
    std::unique_ptr<BlockSolverX::LinearSolverType> linearSolver;
    linearSolver = g2o::make_unique<LinearSolverCSparse<BlockSolverX::PoseMatrixType>>();
    //OptimizationAlgorithmLevenberg* solver = new OptimizationAlgorithmLevenberg(std::move(g2o::make_unique<BlockSolverX>(std::move(linearSolver))));
    OptimizationAlgorithmDogleg* solver = new OptimizationAlgorithmDogleg(std::move(g2o::make_unique<BlockSolverX>(std::move(linearSolver))));
    optimizer.setAlgorithm(solver);

    SparseOptimizerTerminateAction* terminateAction = new SparseOptimizerTerminateAction;
    terminateAction->setGainThreshold(1e-4);
    optimizer.addPostIterationAction(terminateAction);

    g2o::ParameterSE3Offset* cameraOffset = new g2o::ParameterSE3Offset;
    cameraOffset->setId(0);
    optimizer.addParameter(cameraOffset);

    // add vertices
    for (size_t i=0; i<camera_vertices.size(); ++i) {
        g2o::VertexSE3 *v_se3 = new g2o::VertexSE3();
        v_se3->setId(camera_vertices.at(i));
        //if (i < 1) v_se3->setFixed(true);
        v_se3->setEstimate(init_camera_poses.at(i));
        optimizer.addVertex(v_se3);
    }
    for(size_t i=0; i<point_vertices.size(); ++i) {
        g2o::VertexPointXYZ *v_p = new g2o::VertexPointXYZ();
        v_p->setId(point_vertices.at(i));
        v_p->setEstimate(init_point_positions.at(i));
        optimizer.addVertex(v_p);
    }
    for(size_t i=0; i<motion_vertices.size(); ++i) {
        g2o::VertexSE3 *m_se3 = new g2o::VertexSE3();
        m_se3->setId(motion_vertices.at(i));
        m_se3->setEstimate(init_object_motions.at(i));
        optimizer.addVertex(m_se3);
    }

    // add edges
    g2o::EdgeSE3Prior * pose_prior = new g2o::EdgeSE3Prior();
    pose_prior->setVertex(0, optimizer.vertex(camera_vertices.at(0)));
    pose_prior->setMeasurement(gt_camera_poses.at(0));
    pose_prior->information() =  MatrixXd::Identity(6, 6)*10000;
    pose_prior->setParameterId(0, 0);
    optimizer.addEdge(pose_prior);

    g2o::EdgeXYZPrior * point_prior = new g2o::EdgeXYZPrior();
    point_prior->setVertex(0, optimizer.vertex(point_vertices.at(0)));
    point_prior->setMeasurement(gt_point_positions.at(0));
    point_prior->information() =  Matrix3::Identity()*10000;
    optimizer.addEdge(pose_prior);

    for (size_t i=0; i<odom_measurements_vertices.size(); ++i) {
        g2o::EdgeSE3 * ep = new g2o::EdgeSE3();
        ep->setVertex(0, optimizer.vertex(odom_measurements_vertices.at(i)[0]));
        ep->setVertex(1, optimizer.vertex(odom_measurements_vertices.at(i)[1]));
        ep->setMeasurement(odom_measurements.at(i));
        ep->information() = odom_measurements_information.at(i);
        if (ROBUST_KERNEL) {
            g2o::RobustKernelHuber* rk = new g2o::RobustKernelHuber;
            ep->setRobustKernel(rk);
            ep->robustKernel()->setDelta(0.01);
        }
        optimizer.addEdge(ep);
    }
    for (size_t i=0; i<point_measurements_vertices.size(); ++i) {
        g2o::EdgeSE3PointXYZ * e = new g2o::EdgeSE3PointXYZ();
        e->setVertex(0, optimizer.vertex(point_measurements_vertices.at(i)[0]));
        e->setVertex(1, optimizer.vertex(point_measurements_vertices.at(i)[1]));
        e->setMeasurement(point_measurements.at(i));
        e->information() = point_measurements_information.at(i);
        if (ROBUST_KERNEL) {
            g2o::RobustKernelHuber* rk = new g2o::RobustKernelHuber;
            e->setRobustKernel(rk);
            e->robustKernel()->setDelta(0.1);
        }
        e->setParameterId(0, 0);
        optimizer.addEdge(e);
    }

    for (size_t i=0; i<data_associations_vertices.size(); ++i) {
        g2o::LandmarkMotionTernaryEdge * em = new g2o::LandmarkMotionTernaryEdge();
        em->setVertex(0, optimizer.vertex(data_associations_vertices.at(i)[0]));
        em->setVertex(1, optimizer.vertex(data_associations_vertices.at(i)[1]));
        em->setVertex(2, optimizer.vertex(data_associations_vertices.at(i)[2]));
        em->setMeasurement(Vector3d(0,0,0));
        em->information() = Matrix3d::Identity()*100;
        if (ROBUST_KERNEL) {
            g2o::RobustKernelHuber* rk = new g2o::RobustKernelHuber;
            em->setRobustKernel(rk);
            em->robustKernel()->setDelta(0.01);
        }
        optimizer.addEdge(em);
    }

    for (size_t i=0; i<motion_vertices.size(); ++i) {
        g2o::EdgeSE3Altitude * ea = new g2o::EdgeSE3Altitude();
        ea->setVertex(0, optimizer.vertex(motion_vertices.at(i)));
        ea->setMeasurement(0);
        Matrix<double, 1, 1> altitude_information(25);
        ea->information() = altitude_information;
        optimizer.addEdge(ea);
    }

    optimizer.initializeOptimization();
    optimizer.setVerbose(true);

    optimizer.save("dynamic_slam_graph_before_opt.g2o");
    optimizer.optimize(1000);
    optimizer.save("dynamic_slam_graph_after_opt.g2o");
}
