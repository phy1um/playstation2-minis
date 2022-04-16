
ENGINE_HASH=73487f675db89a0e5636bfe3d23602365d834301
DOIN=$(cd engine && make )

.PHONY: get-engine
get-engine:
	git clone https://github.com/phy1um/ps2-homebrew-livestreams engine
	cd engine && git checkout $(ENGINE_HASH)

.PHONY: run
run: scripts assets
	cd engine && make run	

.PHONY: runlove
runlove: scripts assets
	cd engine && love .

.PHONY: docker-elf
docker-elf:
	make -C engine assets
	make -C engine docker-elf

.PHONY: clean
clean:
	make -C engine clean

.PHONY: runps2
runps2: scripts
	make -C engine runps2

.PHONY: resetps2
resetps2:
	make -C engine resetps2

.PHONY: scripts
scripts:
	cp -r script/* engine/script/

.PHONY: assets
assets:
	cp -r asset/* engine/asset/
	make -C engine assets

.PHONY: lualint
lualint:
	luac5.3 -p $(shell find script -type f -name "*.lua")

.PHONY: package
package:
	mkdir pew
	cp -r engine/dist/* pew
	7z a pew.zip pew
	rm -rf pew/


.PHONY: grab
grab:
	cp ~/workspace/playstation2/ps2-homebrew-engine/dist/test.elf engine/dist/test.elf

