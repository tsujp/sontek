# Sontek

Bash only paged menu selection.

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

1. Ensure the [prerequisites](#prerequisites) after this block are met.
2. Source in Sontek, `source "path/to/sontek.bash"`.
3. Determine the absolute path to a directory following [`defs` pattern](#defs-directory).
4. Call `select_option "$path"` (e.g., `$path` evaluates to that directory).

[Example usage in my dotfiles repo can be found here within `setup.bash`](https://github.com/tsujp/dotfiles/tree/master/meta-config).


### Prerequisites

*Note*
- In the following N refers to the set of ISO 80000-2 natural numbers (i.e.
0, 1, 2 ...).
- Naming conventions involving `N-` have the preceeding integer and hyphen
stripped from display.

#### `defs` directory

- A directory for which each subdirectory is a menu category.
- When a subdirectory with only files is reached said subdirectory represents
the final option in the chain which then has its contents presented as menu choices beneath those subdirectories.

#### Directory names

- Directories are named `N-NAME` to allow ordered presentation.

#### File names

- The files within the terminal directory are named `N-NAME.bash` and represent
both the order of execution as well as presentation in Sontek.

#### Extra

- Specially named directories `-common` as well as empty directories are
ignored.


### Example

```
todo
```
