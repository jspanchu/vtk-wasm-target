FROM dockcross/web-wasm:20230116-670f7f7
LABEL maintainer="Jaswant Panchumarti jaswant.panchumarti@kitware.com"

WORKDIR /vtk-wasm
RUN git clone --progress --verbose https://gitlab.kitware.com/jaswant.panchumarti/vtk.git src

WORKDIR /vtk-wasm/src
RUN git submodule update --init --recursive
RUN git config --global user.email "jaswant.panchumarti@kitware.com" && \
    git config --global user.name "Jaswant Panchumarti" && \
    git rebase origin/webassembly-build-ci
RUN .gitlab/ci/sccache.sh
RUN cmake --version && \
    ninja --version && \
    export PATH=/vtk-wasm/src/.gitlab:$PATH && \
    sccache --version
RUN export CMAKE_CONFIGURATION=webassembly && \
    export PATH=/vtk-wasm/src/.gitlab:$PATH && \
    ctest -VV -S .gitlab/ci/ctest_configure.cmake
RUN export CMAKE_CONFIGURATION=webassembly && \
    export PATH=/vtk-wasm/src/.gitlab:$PATH && \
    ctest -VV -S .gitlab/ci/ctest_build.cmake

RUN cmake --install build --prefix /vtk-wasm/install
RUN rm -rf /vtk-wasm/src

ENV VTK_DIR=/vtk-wasm/install/lib/cmake/vtk-9.2
