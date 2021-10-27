FROM dockcross/web-wasm:latest
LABEL maintainer="Jaswant Panchumart jspanchu@gmail.com"
WORKDIR /vtk-wasm-project
RUN git clone --progress --verbose https://github.com/jspanchu/vtk-cmake-incantations.git && \
    git clone --progress --verbose https://gitlab.kitware.com/jspanchu/vtk.git src && \
    cd src && \
    git checkout implement-keycode-sdl2 && \
    git submodule update --init --recursive && \
    cd .. && \
    mkdir build && \
    ./vtk-cmake-incantations/wasm-emscripten.sh ./src ./build && \
    cd ./build && \
    ninja && \
    ninja install && \
    cd .. && \
    rm -rf src build vtk-cmake-incantations
