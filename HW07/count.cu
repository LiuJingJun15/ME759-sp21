#include<cuda.h>
#include<iostream>
#include <chrono>
#include <random>
#include <thrust/reduce.h>
#include <thrust/system/cuda/execution_policy.h>
#include <thrust/system/omp/execution_policy.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/copy.h>
#include <thrust/fill.h>
#include <thrust/transform.h>
#include <thrust/functional.h>
#include <thrust/iterator/zip_iterator.h>
#include <thrust/tuple.h>
#include <thrust/sort.h>
#include <thrust/inner_product.h>

#include "count.cuh"

typedef thrust::tuple<int, int>       Tuple2;
struct find_occurence {
    __host__ __device__
        Tuple2 operator()(Tuple2 t) {
        int x, y; thrust::tie(x, y) = t;
        int u = x;
        int v = y/x;
        return Tuple2(u, v);
    }
};


void count(const thrust::device_vector<int>& d_in,
    thrust::device_vector<int>& values,
    thrust::device_vector<int>& counts) {

    int n = d_in.end() - d_in.begin();
    thrust::device_vector<int> d_in_copy(n);
    thrust::copy(thrust::device, d_in.begin(), d_in.end(), d_in_copy.begin());

    thrust::sort(thrust::device, d_in_copy.begin(), d_in_copy.end());

    int sizeval = thrust::inner_product(d_in_copy.begin(), d_in_copy.end() - 1,
        d_in_copy.begin() + 1,
        0,
        thrust::plus<int>(),
        thrust::not_equal_to<int>()) + 1;

    values.resize(sizeval);

    thrust::fill(counts.begin(), counts.end(), 1);
    thrust::reduce_by_key(d_in_copy.begin(), d_in_copy.end(), counts.begin(), values.begin(), counts.begin());

    counts.resize(sizeval);
    /*
    thrust::transform(thrust::make_zip_iterator(thrust::make_tuple(values.begin(), counts.begin())),
        thrust::make_zip_iterator(thrust::make_tuple(values.end(), counts.end())),
        thrust::make_zip_iterator(thrust::make_tuple(values.begin(), counts.begin())),
        find_occurence());
    
    for (int i = 0; i < sizeval; i++){
         counts[i] = counts[i]/values[i];
    }
    */
}
