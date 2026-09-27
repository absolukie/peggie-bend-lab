# Peggie Bend Lab

A **Bend 2 experiment**: a procedural peg-board generator for a Peggle-like
game, with a **machine-checked proof** about it — written in
[Bend](https://github.com/bendlang/bend)'s `LAWS.bend` system.

This is a proof-of-concept, not the game. (See
[What this is / isn't](#what-this-is--isnt).)

## What it proves

**The law, in plain English:** *"The board generator emits exactly one
target peg per requested cell — no more, no fewer — for every possible
input."*

In `board.bend`:

```python
law gen_board_count:
  for cells: List<Nat>
  {count_targets(gen_board(cells)) == num_cells(cells) : Nat}
```

The proof (`def gen_board_count`) is induction on the cell list: the base
case closes by computation (`{==}`), and the step case unfolds one peg
(a `Target`, contributing exactly 1), rewrites with the induction
hypothesis (`%gen_board_count(cs) : ...`), and closes by reflexivity.

The model mirrors Peggie's real peg roles: `Target` (orange — must be
cleared) vs `Filler` (blue — points only).

## Run it

Install Bend 2:

```sh
curl -fsSL https://bend-lang.com/install.sh | sh
```

Verify the proof (this is the gate — it fails while any law is open or false):

```sh
bend board.bend --check-only
# All terms check.
```

Watch the generator run (5 cells in → 5 targets out):

```sh
bend demo.bend
# 5n
```

## What this is / isn't

- **Is:** a small, real machine-checked proof about game-adjacent logic —
  the kind of "proofed" building block Bend 2's `LAWS.bend` was made for.
- **Isn't:** the Peggie game. Bend 2's `Window` effect explicitly fails in
  the JavaScript target (it prints "no display" and asks for a native
  binary), so a Bend game would be **desktop-native only** — no web, no
  PWA, no iPhone. Peggie stays in JavaScript, where it ships.
- **Isn't:** a claim about gameplay. The proof covers exactly one
  invariant (the generator's target count), not physics, rendering, or fun.

## Files

| File         | What                                          |
|--------------|-----------------------------------------------|
| `board.bend` | Peg model, generator, the law, and its proof  |
| `demo.bend`  | Runnable demo: generate a board, count targets |
| `README.md`  | This file                                     |
| `LICENSE`    | MIT                                           |

## Notes from building it

- Bend 2.0.29 moved fast: bare operators now need type annotations
  (`(a + b : Nat)`), and nullary constructors need braces everywhere
  (`Target{}`, including in patterns).
- Pattern-bound variables are linear even for `is Data` types — `p` can't
  be used twice in a `case 1n+p:` body. The generator takes a cell list
  instead of a count partly to respect this.
- Inside `{ }` propositions, function application needs explicit parens:
  `count_targets(gen_board(cells))`, not `count_targets (gen_board cells)`.
