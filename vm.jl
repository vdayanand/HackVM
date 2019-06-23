include("Tokenizer.jl")
include("Parser.jl")
using Main.Tokenizer
using Main.Parser
tokens = Tokenizer.main()
instructions = Parser.main(tokens)
