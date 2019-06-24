include("Tokenizer.jl")
include("Parser.jl")
include("CodeGen.jl")
using Main.Tokenizer
using Main.Parser
using Main.CodeGen

tokens = Tokenizer.main()
instructions = Parser.main(tokens)
asm_str = CodeGen.main(instructions)
open("a.asm", "w") do f
    write(f,  asm_str)

end
