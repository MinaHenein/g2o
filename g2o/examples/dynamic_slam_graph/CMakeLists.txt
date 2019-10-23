add_executable(dynamic_slam_graph_incremental
  #dynamic_slam_graph.cpp
  dynamic_slam_graph_incremental.cpp
)
find_package(OpenCV REQUIRED COMPONENTS core)

include_directories(${CHOLMOD_INCLUDE_DIR})
include_directories(${OpenCV_INCLUDE_DIRS})
include_directories(${CSPARSE_INCLUDE_DIR})

target_link_libraries(dynamic_slam_graph_incremental core solver_csparse solver_cholmod types_slam3d types_sba ${OpenCV_LIBS} ${G2O_SOLVER_CSPARSE_EXTENSION})
