.PHONY: build check clean

build:
	cargo build --release --locked
	mkdir -p bin
	install -m 755 target/release/appearancectl bin/.appearancectl.tmp
	mv bin/.appearancectl.tmp bin/appearancectl

check:
	cargo fmt --check
	cargo clippy --locked --all-targets -- -D warnings
	cargo test --locked

clean:
	cargo clean
	rm -rf bin
