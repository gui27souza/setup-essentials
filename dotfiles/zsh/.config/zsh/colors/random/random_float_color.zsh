# ZSH_DESC - Gera uma cor aleatória no formato "R, G, B"

random_float_color() {
    printf "%.4f, %.4f, %.4f\n" $(( RANDOM / 32767.0 )) $(( RANDOM / 32767.0 )) $(( RANDOM / 32767.0 ))
}
