#include "vertex_se3.h"
#include "edge_se3.h"
#include "g2o/core/base_unary_edge.h"

namespace g2o {

    class EdgeSE3Altitude: public BaseUnaryEdge<1, double, VertexSE3>
    {
    public:
        EdgeSE3Altitude();

        virtual bool read(std::istream& is);
        virtual bool write(std::ostream& os) const;
        void computeError();
        void linearizeOplus();

        virtual void setMeasurement(const double& m){
            _measurement = m;
        }

    private:
        Eigen::Matrix<number_t,1,6,Eigen::RowMajor> J;
    };
}
