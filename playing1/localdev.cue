package main

import (
    "strings"
    "dagger.io/dagger"
    "dagger.io/dagger/core"
)

dagger.#Plan & {
    client: commands: {
        os: {
            // notice: this command isn't available on Windows
            name: "uname"
            args: ["-s"]
        }
        arch: {
            name: "uname"
            args: ["-m"]
        }

        go: {
            name: "go"
            args: ["version"]
        }
        hugo: {
            name: "hugo"
            args: ["version"]
        }
    }

    actions: test: {
        // using #Nop because we need an action for the outputs
        _os: core.#Nop & {
            // command outputs usually add a new line, you can trim it
            input: strings.TrimSpace(client.commands.os.stdout)
        }
        _arch: core.#Nop & {
            // we access the command's output via the `stdout` field
            input: strings.TrimSpace(client.commands.arch.stdout)
        }
         _go: core.#Nop & {
            // we access the command's output via the `stdout` field
            input: strings.TrimSpace(client.commands.go.stdout)
        }
          _hugo: core.#Nop & {
            // we access the command's output via the `stdout` field
            input: strings.TrimSpace(client.commands.hugo.stdout)
        }
        // action outputs for debugging
        os:   _os.output
        arch: _arch.output
        go: _go.output
        hugo: _hugo.output
    }
}
