REM This assumes EMSDK is installed in the juicebox folder and the juicebox project is cloned next to the project.
pushd export\web
call ..\..\..\juicebox\tools\emsdk\upstream\emscripten\tools\file_packager resources.data --preload resources --js-output=resources.js --no-node
popd