install-hook:
	# Create symlink for pre-commit hook.
	ln -sf ../../tool/pre-commit.sh .git/hooks/pre-commit

generate-bindings:
	dart tool/codegen/generate.dart

fltk_version = "1.3.3"
compile-fltk:
	# 1. untar
	mkdir -p compile
	rm -rf compile/fltk-${fltk_version}
	tar -C ./compile -xvf tar/fltk-${fltk_version}-source.tar.gz

	# 2. compile
	cd compile/fltk-${fltk_version}; ./configure --enable-cairo --enable-shared --enable-debug; make; sudo make install

	# 3. reconfigure dynamic linker run-time bindings
	sudo ldconfig

compile-fltk-ext:
	./tool/compile-ext.sh

compile-example:
	#g++ example/${name}.cpp `fltk-config --use-gl --cxxflags` `fltk-config --use-gl --ldflags`
	g++ \
		-std=c++11\
		-I/usr/local/include\
		-I/usr/include/cairo\
		-I/usr/include/glib-2.0\
		-I/usr/include/pixman-1\
		-I/usr/include/freetype2\
		-I/usr/include/libpng12\
		-I/usr/local/include/FL/images\
		-I/usr/include/freetype2\
		-fvisibility-inlines-hidden\
		-D_LARGEFILE_SOURCE\
		-D_LARGEFILE64_SOURCE\
		-D_THREAD_SAFE\
		-D_REENTRANT\
		-o 'binary' "example/${name}.cpp"\
		-lfltk_cairo\
		-lcairo -lpixman-1\
		-lfltk_gl\
		-lGLU -lGL\
		-lfltk\
		-lXcursor -lXfixes -lXext -lXft -lfontconfig -lXinerama -lpthread -ldl -lm -lX11
	./binary
	rm binary

	# Compiling using FLTK helper binary.
	#fltk-config --use-gl --use-cairo --compile example/${name}.cpp
	#./${name}
	#rm ${name}
