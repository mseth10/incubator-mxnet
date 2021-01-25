# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

set(BLAS "Open" CACHE STRING "Selected BLAS library")
set_property(CACHE BLAS PROPERTY STRINGS "Atlas;Open;MKL")

if(DEFINED USE_BLAS)
  set(BLAS "${USE_BLAS}")
else()
  if(USE_MKL_IF_AVAILABLE)
    if(NOT MKL_FOUND)
      find_package(MKL)
    endif()
    if(MKL_FOUND)
      set(BLAS "MKL")
    endif()
  endif()
endif()

if(BLAS STREQUAL "Atlas" OR BLAS STREQUAL "atlas")
  find_package(Atlas REQUIRED)
  include_directories(SYSTEM ${Atlas_INCLUDE_DIR})
  list(APPEND mshadow_LINKER_LIBS ${Atlas_LIBRARIES})
  add_definitions(-DMSHADOW_USE_CBLAS=1)
  add_definitions(-DMSHADOW_USE_MKL=0)
  add_definitions(-DMXNET_USE_BLAS_ATLAS=1)
elseif(BLAS STREQUAL "Open" OR BLAS STREQUAL "open")
  find_package(OpenBLAS REQUIRED)
  include_directories(SYSTEM ${OpenBLAS_INCLUDE_DIR})
  list(APPEND mshadow_LINKER_LIBS ${OpenBLAS_LIB})
  add_definitions(-DMSHADOW_USE_CBLAS=1)
  add_definitions(-DMSHADOW_USE_MKL=0)
  add_definitions(-DMXNET_USE_BLAS_OPEN=1)
elseif(BLAS STREQUAL "MKL" OR BLAS STREQUAL "mkl")
  find_package(MKL REQUIRED)
  include_directories(SYSTEM ${MKL_INCLUDE_DIR})
  list(APPEND mshadow_LINKER_LIBS ${MKL_LIBRARIES})
  add_definitions(-DMSHADOW_USE_CBLAS=0)
  add_definitions(-DMSHADOW_USE_MKL=1)
  add_definitions(-DMXNET_USE_BLAS_MKL=1)
elseif(BLAS STREQUAL "apple")
  find_package(Accelerate REQUIRED)
  include_directories(SYSTEM ${Accelerate_INCLUDE_DIR})
  list(APPEND mshadow_LINKER_LIBS ${Accelerate_LIBRARIES})
  add_definitions(-DMSHADOW_USE_MKL=0)
  add_definitions(-DMSHADOW_USE_CBLAS=1)
  add_definitions(-DMXNET_USE_BLAS_APPLE=1)
elseif(BLAS STREQUAL "armpl")
  include_directories(SYSTEM /home/ubuntu/arm_dir/armpl_20.3_gcc-7.1/include_lp64_mp)
  list(APPEND mshadow_LINKER_LIBS /home/ubuntu/arm_dir/armpl_20.3_gcc-7.1/lib/libarmpl_lp64_mp.so)
  list(APPEND mshadow_LINKER_LIBS /usr/aarch64-linux-gnu/lib/libgfortran.so.5)
  list(APPEND mshadow_LINKER_LIBS /home/ubuntu/arm_dir/armpl_20.3_gcc-7.1/lib/libamath.so)
  add_definitions(-DMSHADOW_USE_CBLAS=1)
  add_definitions(-DMSHADOW_USE_MKL=0)
  add_definitions(-DMXNET_USE_ARMPL=1)
  add_definitions(-DMXNET_USE_LAPACK=1)
endif()
