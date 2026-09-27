import Base

# ---------------------------------------------------------------------------
# Peggie board model (mirrors the web game's peg roles)
# ---------------------------------------------------------------------------

# Peg roles, mirroring Peggie: Target (orange - must be cleared to win the
# battle) and Filler (blue - worth points but not required).
type Role is Data:
  Target{}
  Filler{}

# A peg: a role plus a linear cell index into the W*H board grid.
type Peg is Data:
  MkPeg{role: Role, cell: Nat}

# 1 if the peg is a target, else 0.
def is_target(peg: Peg) -> Nat:
  match peg:
    case MkPeg{role, cell}:
      match role:
        case Target{}:
          1n
        case Filler{}:
          0n

# Count the target pegs on a board.
def count_targets(board: List<Peg>) -> Nat:
  match board:
    case Nil{}:
      0n
    case peg <> rest:
      Nat.add(is_target(peg), count_targets(rest))

# How many cells were requested.
def num_cells(cells: List<Nat>) -> Nat:
  match cells:
    case Nil{}:
      0n
    case c <> cs:
      Nat.add(1n, num_cells(cs))

# Procedural generator: given a list of board cells (e.g. 0..k-1, or a
# seeded permutation of them), emit one target peg per cell.
# The caller owns placement; the generator owns the count invariant.
def gen_board(cells: List<Nat>) -> List<Peg>:
  match cells:
    case Nil{}:
      Nil{}
    case c <> cs:
      MkPeg{Target{}, c} <> gen_board(cs)

# ---------------------------------------------------------------------------
# LAW: the generator emits exactly one target peg per requested cell -
# no more, no fewer. For every cell list.
# In plain English: "ask for k targets, get k targets."
# ---------------------------------------------------------------------------
law gen_board_count:
  for cells: List<Nat>
  {count_targets(gen_board(cells)) == num_cells(cells) : Nat}

# PROOF: induction on the cell list.
# - Base (no cells): both sides compute to 0; closed by reflexivity.
# - Step (c :: cs): unfold one peg. It is a Target, so it contributes
#   exactly 1 to the count. Apply the induction hypothesis to the tail,
#   rewrite the goal with it, and close by reflexivity.
def gen_board_count(cells):
  match cells:
    case Nil{}:
      {==}
    case c <> cs:
      %gen_board_count(cs) : {Nat.add(1n, count_targets(gen_board(cs))) == Nat.add(1n, _) : Nat}
      {==}
