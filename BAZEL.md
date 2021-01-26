# Experimental Bazel build

`brew install bazelisk`

Additionally, create a `.bazelrc` file with at least:

```
build --//bazel_erlang:erlang_version=ERLANG_VERSION
build --//bazel_erlang:erlang_home=/path/to/erlang/installation
build --//bazel_erlang:elixir_home=/path/to/elixir/installation
build --//bazel_erlang:mix_archives=~/.mix/archives
```

Your `mix_archives` is likely different than above if you have used kiex for elixir.

Additionally, on **macOS**, you will likely need to add

```
build --spawn_strategy=local
```

for certain `rabbitmq_cli` tests to pass. This is because `rabbitmqctl wait` shells out to 'ps', which is broken in the bazel macOS (https://github.com/bazelbuild/bazel/issues/7448).

## Run the broker

`bazel run broker`

## Running tests

### Run all tests (for Erlang 22 & 23)

`bazel test //...`

or just Erlang 23

`bazel test --test_tag_filters="erlang-23.1" --build_tests_only //...`

### Run tests in a 'package' and its 'subpackages'

`bazel test deps/rabbit_common/...`

### Run tests for a specific 'package'

`bazel test deps/rabbit:all`
