
ENGINE_HASH=b949e69c428c47613b5ac0258f5f077f054cc2f3
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
	cp main.lua engine/

.PHONY: assets
assets:
	cp -r asset/* engine/asset/
	make -C engine assets

.PHONY: lualint
lualint:
	luac5.3 -p $(shell find script -type f -name "*.lua")
