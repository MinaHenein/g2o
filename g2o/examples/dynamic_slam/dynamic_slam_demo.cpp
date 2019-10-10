#include <Eigen/StdVector>
#include <iostream>
#include <stdint.h>

#include "g2o/core/sparse_optimizer.h"
#include "g2o/core/block_solver.h"
#include "g2o/core/solver.h"
#include "g2o/core/optimization_algorithm_levenberg.h"
#include "g2o/solvers/cholmod/linear_solver_cholmod.h"
#include "g2o/solvers/dense/linear_solver_dense.h"
#include "g2o/solvers/csparse/linear_solver_csparse.h"
#include "g2o/types/sba/types_six_dof_expmap.h"
#include "g2o/types/slam3d/types_slam3d.h"

using namespace Eigen;
using namespace std;
using namespace g2o;

int main(){

  SparseOptimizer optimizer;
  optimizer.setVerbose(true);
  std::unique_ptr<BlockSolverX::LinearSolverType> linearSolver;
  //std::unique_ptr<BlockSolver_6_3::LinearSolverType> linearSolver;
  linearSolver = g2o::make_unique<LinearSolverDense<BlockSolverX::PoseMatrixType>>();
  //linearSolver = g2o::make_unique<LinearSolverDense<BlockSolver_6_3::PoseMatrixType>>();
  //linearSolver = g2o::make_unique<LinearSolverCSparse<BlockSolverX::PoseMatrixType>>();
  OptimizationAlgorithmLevenberg* solver = new OptimizationAlgorithmLevenberg(std::move(g2o::make_unique<BlockSolverX>(std::move(linearSolver))));
  //OptimizationAlgorithmLevenberg* solver = new OptimizationAlgorithmLevenberg(std::move(g2o::make_unique<BlockSolver_6_3>(std::move(linearSolver))));
  optimizer.setAlgorithm(solver);


  g2o::ParameterSE3Offset* cameraOffset = new g2o::ParameterSE3Offset;
  cameraOffset->setId(0);
  optimizer.addParameter(cameraOffset);

  Matrix<double,4,4> pose1_init;
  Matrix<double,4,4> pose2_init;
  Matrix<double,4,4> pose3_init;

  pose1_init << 0.9823, 0.1860, 0.0204, -0.6088, -0.1861, 0.9825, 0.0021, -2.3902, -0.0196, -0.0059, 0.9998, -0.1250, 0, 0, 0, 1;
  pose2_init << 0.9827, 0.1822, 0.0322, 0.0696, -0.1828, 0.9831, 0.0144, -2.2282, -0.0290, -0.0201, 0.9994, -0.1677, 0, 0, 0, 1;
  pose3_init << 0.9816, 0.1865, 0.0411, 0.7509, -0.1879, 0.9816, 0.0328, -2.0811, -0.0342, -0.0399, 0.9986, -0.2243, 0, 0, 0, 1;

  g2o::VertexSE3 * v1_se3 = new g2o::VertexSE3();
  v1_se3->setId(1);
  v1_se3->setFixed(true);
  Matrix<double,3,3> R1 = pose1_init.block<3,3>(0,0);
  Matrix<double,3,1> t1 = pose1_init.block<3,1>(0,3);
  v1_se3->setEstimate(g2o::SE3Quat(R1,t1));
  optimizer.addVertex(v1_se3);

  g2o::VertexSE3 * v2_se3 = new g2o::VertexSE3();
  v2_se3->setId(4);
  Matrix<double,3,3> R2 = pose2_init.block<3,3>(0,0);
  Matrix<double,3,1> t2 = pose2_init.block<3,1>(0,3);
  v2_se3->setEstimate(g2o::SE3Quat(R2,t2));
  optimizer.addVertex(v2_se3);

  g2o::VertexSE3 * v3_se3 = new g2o::VertexSE3();
  v3_se3->setId(8);
  Matrix<double,3,3> R3 = pose3_init.block<3,3>(0,0);
  Matrix<double,3,1> t3 = pose3_init.block<3,1>(0,3);
  v3_se3->setEstimate(g2o::SE3Quat(R3,t3));
  optimizer.addVertex(v3_se3);

  g2o::VertexSE3 * m_se3 = new g2o::VertexSE3();
  m_se3->setId(11);
  m_se3->setEstimate(g2o::SE3Quat(Matrix3d::Identity(),Matrix<double,3,1>::Zero()));
  optimizer.addVertex(m_se3);

  g2o::VertexPointXYZ * v1_p = new g2o::VertexPointXYZ();
  v1_p->setId(2);
  v1_p->setEstimate(Vector3d(5.455006, -0.991931, -1.139216));
  optimizer.addVertex(v1_p);

  g2o::VertexPointXYZ * v2_p = new g2o::VertexPointXYZ();
  v2_p->setId(3);
  v2_p->setEstimate(Vector3d(8.117664, -0.384841, -2.780660));
  optimizer.addVertex(v2_p);

  g2o::VertexPointXYZ * v3_p = new g2o::VertexPointXYZ();
  v3_p->setId(5);
  v3_p->setEstimate(Vector3d(6.910144, -0.817468, -1.311540));
  optimizer.addVertex(v3_p);

  g2o::VertexPointXYZ * v4_p = new g2o::VertexPointXYZ();
  v4_p->setId(6);
  v4_p->setEstimate(Vector3d(9.568038, -0.131493, -2.940033));
  optimizer.addVertex(v4_p);

  g2o::VertexPointXYZ * v5_p = new g2o::VertexPointXYZ();
  v5_p->setId(7);
  v5_p->setEstimate(Vector3d(10.938935, 2.194117, -0.201493));
  optimizer.addVertex(v5_p);

  g2o::VertexPointXYZ * v6_p = new g2o::VertexPointXYZ();
  v6_p->setId(9);
  v6_p->setEstimate(Vector3d(8.376776, -0.784970, -1.428021));
  optimizer.addVertex(v6_p);

  g2o::VertexPointXYZ * v7_p = new g2o::VertexPointXYZ();
  v7_p->setId(10);
  v7_p->setEstimate(Vector3d(10.975083, -0.046284, -3.106853));
  optimizer.addVertex(v7_p);

    //Matrix<double,4,4> pose_prior;
    //pose_prior << 0.9823, 0.1860, 0.0204, -0.6088, -0.1861, 0.9825, 0.0021, -2.3902, -0.0196, -0.0059, 0.9998, -0.1250, 0, 0, 0, 1;
    //g2o::EdgeSE3Prior * prior = new g2o::EdgeSE3Prior();
    //prior->setVertex(0, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v1_se3));
    //Matrix<double,3,3> prior_R = pose_prior.block<3,3>(0,0);
    //Matrix<double,3,1> prior_t = pose_prior.block<3,1>(0,3);
    //prior->setMeasurement(g2o::SE3Quat(prior_R,prior_t));
    //prior->information() =  MatrixXd::Identity(6, 6)*10000;
    //optimizer.addEdge(prior);
  
  Matrix<double,4,4> odom1;
  odom1 << 1.0000, -0.0036, 0.0093, 0.6371, 0.0034, 0.9999, 0.0143, 0.2856, -0.0094, -0.0143, 0.9999, -0.0285, 0, 0, 0, 1;
  g2o::EdgeSE3 * ep1 = new g2o::EdgeSE3();
  ep1->setVertex(0, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v1_se3));
  ep1->setVertex(1, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v2_se3));
  Matrix<double,3,3> odom1_R = odom1.block<3,3>(0,0);
  Matrix<double,3,1> odom1_t = odom1.block<3,1>(0,3);
  ep1->setMeasurement(g2o::SE3Quat(odom1_R,odom1_t));
  Matrix<double,6,6> odomCov;
  odomCov << 1111, 0, 0, 0, 0, 0, 0, 1111, 0, 0, 0, 0, 0, 0, 1111, 0, 0, 0,
  0, 0, 0, 3344, 0, 0, 0, 0, 0, 0, 3225, 0, 0, 0, 0, 0, 0, 3344;
  ep1->information() = odomCov;
  optimizer.addEdge(ep1);

  Matrix<double,4,4> odom2;
  odom2 << 1.0000, 0.0051, 0.0054, 0.6444, -0.0052, 0.9998, 0.0196, 0.2699, -0.0053, -0.0197, 0.9998, -0.0324, 0, 0, 0, 1;
  g2o::EdgeSE3 * ep2 = new g2o::EdgeSE3();
  ep2->setVertex(0, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v2_se3));
  ep2->setVertex(1, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v3_se3));
  Matrix<double,3,3> odom2_R = odom2.block<3,3>(0,0);
  Matrix<double,3,1> odom2_t = odom2.block<3,1>(0,3);
  ep2->setMeasurement(g2o::SE3Quat(odom2_R,odom2_t));
  ep2->information() = odomCov;
  optimizer.addEdge(ep2);
  
  g2o::EdgeSE3PointXYZ * e1 = new g2o::EdgeSE3PointXYZ();
  e1->setVertex(0, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v1_se3));
  e1->setVertex(1, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v1_p));
  e1->setMeasurement(Vector3d(5.716374, 2.507810, -0.887479));
  e1->information() = Matrix3d::Identity()*1111;
  e1->setParameterId(0, 0);
  optimizer.addEdge(e1);
  
  g2o::EdgeSE3PointXYZ * e2 = new g2o::EdgeSE3PointXYZ();
  e2->setVertex(0, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v1_se3));
  e2->setVertex(1, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v2_p));
  e2->setMeasurement(Vector3d(8.251219, 3.609251, -2.473049));
  e2->information() = Matrix3d::Identity()*1111;
  e2->setParameterId(0, 0);
  optimizer.addEdge(e2);

  g2o::EdgeSE3PointXYZ * e3 = new g2o::EdgeSE3PointXYZ();
  e3->setVertex(0, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v2_se3));
  e3->setVertex(1, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v3_p));
  e3->setMeasurement(Vector3d(6.497795, 2.656342, -0.902546));
  e3->information() = Matrix3d::Identity()*1111;
  e3->setParameterId(0, 0);
  optimizer.addEdge(e3);

  g2o::EdgeSE3PointXYZ * e4 = new g2o::EdgeSE3PointXYZ();
  e4->setVertex(0, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v2_se3));
  e4->setVertex(1, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v4_p));
  e4->setMeasurement(Vector3d(9.031653, 3.847740, -2.434566));
  e4->information() = Matrix3d::Identity()*1111;
  e4->setParameterId(0, 0);
  optimizer.addEdge(e4);

  g2o::EdgeSE3PointXYZ * e5 = new g2o::EdgeSE3PointXYZ();
  e5->setVertex(0, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v2_se3));
  e5->setVertex(1, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v5_p));
  e5->setMeasurement(Vector3d(9.874384, 6.328777, 0.379982));
  e5->information() = Matrix3d::Identity()*1111;
  e5->setParameterId(0, 0);
  optimizer.addEdge(e5);
  
  g2o::EdgeSE3PointXYZ * e6 = new g2o::EdgeSE3PointXYZ();
  e6->setVertex(0, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v3_se3));
  e6->setVertex(1, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v6_p));
  e6->setMeasurement(Vector3d(7.283048, 2.742938, -0.846354));
  e6->information() = Matrix3d::Identity()*1111;
  e6->setParameterId(0, 0);
  optimizer.addEdge(e6);

  g2o::EdgeSE3PointXYZ * e7 = new g2o::EdgeSE3PointXYZ();
  e7->setVertex(0, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v3_se3));
  e7->setVertex(1, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v7_p));
  e7->setMeasurement(Vector3d(9.752133, 4.019721, -2.391921));
  e7->information() = Matrix3d::Identity()*1111;
  e7->setParameterId(0, 0);
  optimizer.addEdge(e7);

  g2o::LandmarkMotionTernaryEdge * em1 = new g2o::LandmarkMotionTernaryEdge();
  em1->setVertex(0, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v1_p));
  em1->setVertex(1, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v3_p));
  em1->setVertex(2, dynamic_cast<g2o::OptimizableGraph::Vertex*>(m_se3));
  em1->setMeasurement(Vector3d(0,0,0));
  //em1->setLevel(0);
  em1->information() = Matrix3d::Identity()*10000;
  optimizer.addEdge(em1);

  g2o::LandmarkMotionTernaryEdge * em2 = new g2o::LandmarkMotionTernaryEdge();
  em2->setVertex(0, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v2_p));
  em2->setVertex(1, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v4_p));
  em2->setVertex(2, dynamic_cast<g2o::OptimizableGraph::Vertex*>(m_se3));
  em2->setMeasurement(Vector3d(0,0,0));
  //em2->setLevel(0);
  em2->information() = Matrix3d::Identity()*10000;
  optimizer.addEdge(em2);

  g2o::LandmarkMotionTernaryEdge * em3 = new g2o::LandmarkMotionTernaryEdge();
  em3->setVertex(0, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v3_p));
  em3->setVertex(1, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v6_p));
  em3->setVertex(2, dynamic_cast<g2o::OptimizableGraph::Vertex*>(m_se3));
  em3->setMeasurement(Vector3d(0,0,0));
  //em3->setLevel(0);
  em3->information() = Matrix3d::Identity()*10000;
  optimizer.addEdge(em3);

  g2o::LandmarkMotionTernaryEdge * em4 = new g2o::LandmarkMotionTernaryEdge();
  em4->setVertex(0, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v4_p));
  em4->setVertex(1, dynamic_cast<g2o::OptimizableGraph::Vertex*>(v7_p));
  em4->setVertex(2, dynamic_cast<g2o::OptimizableGraph::Vertex*>(m_se3));
  em4->setMeasurement(Vector3d(0,0,0));
  //em4->setLevel(0);
  em4->information() = Matrix3d::Identity()*10000;
  optimizer.addEdge(em4);
  //optimizer.removeEdge(em4);

  optimizer.initializeOptimization(0);
  optimizer.setVerbose(true);

  optimizer.save("dynamic_slam_before_opt.g2o");
  optimizer.optimize(100);
  optimizer.save("dynamic_slam_after_opt.g2o");

  //GTSAM output - saved in:
  //data/mina/workspace/src/Git/gtsam/Data/GraphFiles/app5_results_batch_short.graph
  //5 iterations
  //translation - rotation (axis angle)
  //EST VERTEX_SE3Motion 1.545310 0.258439 0.193898 0.121768 0.037370 -0.050644
  //GT  VERTEX_SE3Motion 1.4826 -0.2018 0.0099 0.0049 0.0011 0.0500

  //G2O output
  //EST VERTEX_SE3Motion 1.41851 -0.10674 -0.153712 -0.0269 0.0000 0.0695
}


