# Sontek

Renders a paged, text based list of options that can be selected by the user.

## Supported keys

Bindings for two keysets, KeyA and KeyB are supported.

```
<KeyA>   / <KeyB>
-----------------
Up       / k
Down     / j
Enter    / l
Backpace / h
```

## Usage

Call `select_option` and Sontek handles the rest, with the following
prerequisites.

Sontek accepts no explicit arguments because configurations for various hosts
are typically split up into many bash scripts, so in order to remove duplicating
efforts the structure of these directories is used to construct the menu
presented.

The expected directory tree is a directory named `defs` for which each subdirectory is a menu category. When a subdirectory with only files is reached said subdirectory represents the final option in the chain which then has its contents presented as menu choices beneath those subdirectories.

In the following N refers to the set of ISO 80000-2 natural numbers (i.e. 0, 1,
2 ...).

Directories are named `N_NAME` to allow ordered presentation. The prefix and
underscore are both removed from display.

The files within the terminal directory are named `N_NAME.sh` and represent
both the order of execution as well as presentation in Sontek. The prefix and
underscore are both removed from display.

Specially named directories `_common` as well as empty directories are ignored.

```
put example here
```


## TODO
print warnings if no permissions to execute script
