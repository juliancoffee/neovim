if(WIN32)
  ExternalProject_Add(unibilium
    PREFIX ${DEPS_BUILD_DIR}
    URL ${UNIBILIUM_URL}
    DOWNLOAD_DIR ${DEPS_DOWNLOAD_DIR}/unibilium
    DOWNLOAD_COMMAND ${CMAKE_COMMAND}
      -DPREFIX=${DEPS_BUILD_DIR}
      -DDOWNLOAD_DIR=${DEPS_DOWNLOAD_DIR}/unibilium
      -DURL=${UNIBILIUM_URL}
      -DEXPECTED_SHA256=${UNIBILIUM_SHA256}
      -DTARGET=unibilium
      -DUSE_EXISTING_SRC_DIR=${USE_EXISTING_SRC_DIR}
      -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/DownloadAndExtractFile.cmake
    PATCH_COMMAND ${GIT_EXECUTABLE} -C ${DEPS_BUILD_DIR}/src/unibilium init
      COMMAND ${GIT_EXECUTABLE} -C ${DEPS_BUILD_DIR}/src/unibilium apply --ignore-whitespace
      ${CMAKE_CURRENT_SOURCE_DIR}/patches/unibilium-Relax-checks-for-extended-capability-to-support-new-.patch
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E copy
      ${CMAKE_CURRENT_SOURCE_DIR}/cmake/UnibiliumCMakeLists.txt
      ${DEPS_BUILD_DIR}/src/unibilium/CMakeLists.txt
      COMMAND ${CMAKE_COMMAND} -E copy
        ${CMAKE_CURRENT_SOURCE_DIR}/msvc-compat/unistd.h
        ${DEPS_BUILD_DIR}/src/unibilium/msvc-compat/unistd.h
      COMMAND ${CMAKE_COMMAND} ${DEPS_BUILD_DIR}/src/unibilium
        -DCMAKE_INSTALL_PREFIX=${DEPS_INSTALL_DIR}
        # Pass toolchain
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_GENERATOR=${CMAKE_GENERATOR}
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --target install --config ${CMAKE_BUILD_TYPE})
else()
  ExternalProject_Add(unibilium
    PREFIX ${DEPS_BUILD_DIR}
    URL ${UNIBILIUM_URL}
    DOWNLOAD_DIR ${DEPS_DOWNLOAD_DIR}/unibilium
    DOWNLOAD_COMMAND ${CMAKE_COMMAND}
      -DPREFIX=${DEPS_BUILD_DIR}
      -DDOWNLOAD_DIR=${DEPS_DOWNLOAD_DIR}/unibilium
      -DURL=${UNIBILIUM_URL}
      -DEXPECTED_SHA256=${UNIBILIUM_SHA256}
      -DTARGET=unibilium
      -DUSE_EXISTING_SRC_DIR=${USE_EXISTING_SRC_DIR}
      -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/DownloadAndExtractFile.cmake
    PATCH_COMMAND patch -d ${DEPS_BUILD_DIR}/src/unibilium -Np1 --input
      ${CMAKE_CURRENT_SOURCE_DIR}/patches/unibilium-Relax-checks-for-extended-capability-to-support-new-.patch
    CONFIGURE_COMMAND ""
    BUILD_IN_SOURCE 1
    BUILD_COMMAND ${MAKE_PRG} CC=${DEPS_C_COMPILER}
                              PREFIX=${DEPS_INSTALL_DIR}
                              CFLAGS=-fPIC
    INSTALL_COMMAND ${MAKE_PRG} PREFIX=${DEPS_INSTALL_DIR} install)
endif()

list(APPEND THIRD_PARTY_DEPS unibilium)
