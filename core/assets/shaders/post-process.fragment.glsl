
uniform sampler2D u_texture;
uniform float u_time;

varying vec2 v_texCoords;
varying vec3 v_fragPosition;

// retorna cor invertida
vec3 invert(vec3 color) {
    return 1.0 - color;
}

// retorna cor em escala de cinza
vec3 toGrayscale(vec3 color) {
    float cinza = 0.2989 * color.x + 0.5870 * color.y + 0.1140 * color.z;
    return cinza;
}

vec3 toSepia(vec3 color){
    vec3 sepia;
    sepia.x = 0.383*color.x + 0.789*color.y + 0.189*color.z;
    sepia.y = 0.349*color.x + 0.680*color.y + 0.168*color.z;
    sepia.z = 0.272*color.x + 0.834*color.y + 0.131*color.z;
    return sepia;
}

vec3 blur(sampler2D tex, vec2 texCoords) {
    // cria um vetor 3x3 contendo o deslocamento de cada pixel adjacente a este
    // (do kernel)
    float offset = 1.0 / 300.0;
    vec2 kernelOffsets[9];
    kernelOffsets[0] = vec2(-offset,  offset);      // cima-esquerda
    kernelOffsets[1] = vec2(      0,  offset);      // cima-meio
    kernelOffsets[2] = vec2( offset,  offset);      // cima-direita
    kernelOffsets[3] = vec2(-offset,       0);      // meio-esquerda
    kernelOffsets[4] = vec2(      0,       0);      // meio-meio
    kernelOffsets[5] = vec2( offset,       0);      // meio-direita
    kernelOffsets[6] = vec2(-offset, -offset);      // baixo-esquerda
    kernelOffsets[7] = vec2(      0, -offset);      // baixo-meio
    kernelOffsets[8] = vec2( offset, -offset);       // baixo-direita

    
    // kernel de blur
    float constantWeight = 1.0 / 16.0;
    /*float kernelWeights[9];
    kernelWeights[0] = constantWeight;
    kernelWeights[1] = constantWeight*2;
    kernelWeights[2] = constantWeight;
    kernelWeights[3] = constantWeight*2;
    kernelWeights[4] = constantWeight;
    kernelWeights[5] = constantWeight*2;
    kernelWeights[6] = constantWeight;
    kernelWeights[7] = constantWeight*2;
    kernelWeights[8] = constantWeight;*/

    // kernel de aguçar imagem (sharpen)
    //float kernelWeights[9] = float[](
    //    -1, -1, -1,
    //    -1,  9, -1,
    //    -1, -1, -1
    //);
    /*float kernelWeights[9];
    kernelWeights[0] = -1;
    kernelWeights[1] = -1;
    kernelWeights[2] = -1;
    kernelWeights[3] = 9.0;
    kernelWeights[4] = -1;
    kernelWeights[5] = -1;
    kernelWeights[6] = -1;
    kernelWeights[7] = -1;
    kernelWeights[8] = -1;*/

    // kernel de detectar bordas
    //float kernelWeight[9] = float[](
    //     1,  1,  1,
    //     1, -9,  1,
    //     1,  1,  1
    //);

    float kernelWeights[9];
    kernelWeights[0] = 1;
    kernelWeights[1] = 1;
    kernelWeights[2] = 1;
    kernelWeights[3] = -9.0;
    kernelWeights[4] = 1;
    kernelWeights[5] = 1;
    kernelWeights[6] = 1;
    kernelWeights[7] = 1;
    kernelWeights[8] = 1;

    // olha na textura quais são as cores dos vizinhos deste pixel
    vec3 neighborsColors[9];
    for (int i = 0; i < 9; i++) {
        neighborsColors[i] = texture(tex, texCoords + kernelOffsets[i]).xyz;
    }

    // aplica a convolução, fazendo com que a cor resultante deste pixel
    // seja uma combinação das cores dos pixels adjacentes (3x3) multiplicadas
    // pelos pesos (do kernel)
    vec3 resultingColor = vec3(0.0);
    for (int i = 0; i < 9; i++) {
        resultingColor += neighborsColors[i] * kernelWeights[i];
    }

    return resultingColor;
}

void main() {
    vec3 colorFromTexture = texture(u_texture, v_texCoords).xyz;
    //gl_FragColor = vec4(toSepia(colorFromTexture), 1.0);
    gl_FragColor = vec4(blur(u_texture,v_texCoords), 1.0);
}