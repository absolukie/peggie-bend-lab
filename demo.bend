import ./board.bend as B

# Evaluate the generator on 5 cells and count the targets.
def main() -> Nat:
  B.count_targets(B.gen_board(0n <> 1n <> 2n <> 3n <> 4n <> Nil{}))
