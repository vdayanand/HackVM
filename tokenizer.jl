module Tokenizer

export Token

@enum TokenType begin
    PUSH
    POP
    ADD
    VARTYPE
    INTEGER
    CHAR
    EOF
    NULL
end


struct Token
    tokentype::TokenType
    value::String
end

struct Scanner
    line_index::Int64
    char_index::Int64
    source::String
end

function recogize_token(token_value)
    if token_value == "push"
        token_type = PUSH
    elseif token_value == "pop"
        token_type = POP
    elseif token_value == "add"
        token_type = ADD
    elseif token_value == "constant"
        token_type = VARTYPE
    elseif isempty(token_value)
        token_type = EOF
    elseif isdigit(token_value[1])
        token_type = INTEGER
    elseif token_value[1] == '\'' && token_value[end] == '\''
        token_type = CHAR
    else
       @error "Tokenizer: Unrecognized token $token_value at $(line_index):$(char_index)"
    end
end

function read_next(scanner)
    token_value = ""
    token_type = NULL
    source  = Scanner.source
    while(scanner.char_index <= length(source))
        if isspace(source[scanner.char_index])
            if isempty(token_value)
                scanner.char_index += 1;
                continue
            else
                token_type = recogize_token(token_value)
                scanner.char_index += 1;
                return Token(token_type, token_value)
           end
            if(source[char_index] == '\n')
                scanner.line_index += 1
            end
        end
        token_value *= source[scanner.char_index]
        scanner.char_index += 1;
    end
    token_type = recogize_token(token_value)
    return Token(token_type, token_value)
end

function main()
    source_file = ARGS[1]
    source = open(source_file) do f
        read(f, String)
    end
    scanner = Scanner(1, 1, source)
    token_list = []
    token = read_next(scanner)
    while(!(token.tokentype == EOF))
        push!(token_list, token)
        token = read_next()
    end
    return token_list
end

end
