project(g-less)
cmake_minimum_required(VERSION 2.8)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/vala)

set(DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set(PKGDATADIR "${DATADIR}/g-less")
set(EXEC_NAME "g-less")
set(RELEASE_NAME "Graphical less")
set(VERSION "0.1")
set(VERSION_INFO "First version")


find_package(Vala REQUIRED)
include (UseVala)

find_package(PkgConfig)
pkg_check_modules(DEPS REQUIRED gtk+-3.0 gtksourceview-3.0 gobject-2.0)

add_definitions(${DEPS_CFLAGS})
add_definitions(-ggdb)
link_libraries(${DEPS_LIBRARIES})
link_directories(${DEPS_LIBRARY_DIRS})

vala_precompile(VALA_C
        src/g_less.vala

        PACKAGES
            gtk+-3.0
            gtksourceview-3.0

        OPTIONS
            --debug
    )


#configure_file (ui/g_less.ui ui/g_less.ui)

add_executable(${EXEC_NAME} ${VALA_C})


install(TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)
#install(FILES ui/g_less.ui DESTINATION "${PKGDATADIR}")
