#include "edge_se3_altitude.h"

namespace g2o {

    using namespace std;
    using namespace Eigen;

EdgeSE3Altitude::EdgeSE3Altitude() : BaseUnaryEdge<1, double, VertexSE3>()
{
   resize(1);
   J.fill(0);
   J[1] = 1;
}

    bool EdgeSE3Altitude::read(std::istream& is)
    {
        double meas;
        is >> meas;
        setMeasurement(meas);
        is >> information()(0);
        return true;
    }

    bool EdgeSE3Altitude::write(std::ostream& os) const
    {
        os  << measurement() << " ";
        os << information()(0) << " ";
        return os.good();
    }

    void EdgeSE3Altitude::computeError()
    {
        VertexSE3* v = static_cast<VertexSE3*>(_vertices[0]);
        _error << v->estimate().translation()[1] - _measurement;
    }

    void EdgeSE3Altitude::linearizeOplus()
    {
        Eigen::Matrix<number_t,1,6,Eigen::RowMajor> Jhom = J;
        _jacobianOplusXi = Jhom;
    }
}
