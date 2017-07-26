# Wercker-gradle

Wercker step to install gradle and run a command.

## Example

```yaml
build:
  steps:
    - gradle:
        command: compile
        version: 4.0.1
```

### Options

- `command` (required): gradle task [install, build, compile].
- `version` (optional): gradle version to use.
