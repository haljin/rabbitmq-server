load("//bazel_erlang:bazel_erlang_lib.bzl", "bazel_erlang_lib")
load("//bazel_erlang:ct.bzl", "ct_test")

_LAGER_EXTRA_SINKS = [
    "rabbit_log",
    "rabbit_log_channel",
    "rabbit_log_connection",
    "rabbit_log_feature_flags",
    "rabbit_log_federation",
    "rabbit_log_ldap",
    "rabbit_log_mirroring",
    "rabbit_log_osiris",
    "rabbit_log_prelaunch",
    "rabbit_log_queue",
    "rabbit_log_ra",
    "rabbit_log_shovel",
    "rabbit_log_upgrade",
]

RABBITMQ_ERLC_OPTS = [
    "+{parse_transform,lager_transform}",
    "+{lager_extra_sinks,[" + ",".join(_LAGER_EXTRA_SINKS) + "]}",
]

APP_VERSION = "3.9.0"

ERLANG_VERSIONS = [
    "23.1",
    "22.3",
]

def erlang_libs(**kwargs):
    app_name = kwargs['app_name']
    deps = kwargs.get('deps', [])
    runtime_deps = kwargs.get('runtime_deps', [])
    for erlang_version in ERLANG_VERSIONS:
        kwargs.update(
            deps = [dep + "@" + erlang_version for dep in deps],
            runtime_deps = [dep + "@" + erlang_version for dep in runtime_deps],
        )
        bazel_erlang_lib(
            name = "{}@{}".format(app_name, erlang_version),
            erlang_version = erlang_version,
            **kwargs
        )
        kwargs2 = dict(kwargs.items())
        erlc_opts = kwargs2.get('erlc_opts', [])
        if "-DTEST" not in erlc_opts:
            kwargs2.update(erlc_opts = erlc_opts + ["-DTEST"])
        bazel_erlang_lib(
            name = "{}_test@{}".format(app_name, erlang_version),
            erlang_version = erlang_version,
            testonly = True,
            **kwargs2
        )

def ct_tests(**kwargs):
    name = kwargs['name']
    deps = kwargs.get('deps', [])
    for erlang_version in ERLANG_VERSIONS:
        kwargs.update(
            name = "{}@{}".format(name, erlang_version),
            deps = [dep + "@" + erlang_version for dep in deps],
        )
        ct_test(
            erlang_version = erlang_version,
            tags = ["erlang-{}".format(erlang_version)],
            **kwargs
        )