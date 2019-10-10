#include "vertex_se3.h"
#include "edge_se3.h"
#include "vertex_pointxyz.h"
#include "g2o/core/base_multi_edge.h"

namespace g2o {

class LandmarkMotionTernaryEdge: public BaseMultiEdge<3,Vector3>
{
    public:
     LandmarkMotionTernaryEdge();

    virtual bool read(std::istream& is);
    virtual bool write(std::ostream& os) const;
    void computeError();
    void linearizeOplus();

    virtual void setMeasurement(const Vector3& m){
      _measurement = m;
    }

private:
    Eigen::Matrix<number_t,3,6,Eigen::ColMajor> J;

};
}
