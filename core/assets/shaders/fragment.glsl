uniform sampler2D u_diffuseTexture;
uniform float u_time;
uniform vec4 u_dirLights0color;
uniform vec3 u_dirLights0direction;
uniform vec4 u_dirLights1color;
uniform vec3 u_dirLights1direction;

varying vec4 v_color;
varying vec2 v_texCoords;
varying vec3 v_fragPosition;
varying vec3 v_fragNormal;

void main() 
{
    // DEBUG: esta cor pode ser usada para "depurar". Pinte o fragmento com ela,
    // que está azulzinha
    vec4 debugColor = vec4(0.5, 0.5, 1.0, 1.0);

    // DEBUG: use este if para mudar a cor para vermelho caso 
    // "algo esteja errado". No final, defina o gl_FragColor como esta cor...
    // se estiver vermelho quer dizer que entrou neste IF (sua condição está
    // verdadeira)
    if (length(u_dirLights0color) > 1.0) {
        debugColor.r = 1.0;
        debugColor.b = 0.5;
    }

    // para calcular a componente difusa, precisamos:
    vec3 normal = normalize(v_fragNormal);
    vec3 incidenciaLuz = normalize(-u_dirLights0direction);

    // para calcular a componente especular, precisamos:
    vec3 visualizacao = normalize(-v_fragPosition);
    vec3 reflexao = normalize(reflect(incidenciaLuz, normal));

    // calcula as 3 componentes de Phong: ambiente, difusa, especular
    vec4 ambiente = vec4(0.15,0.15,0.15,1.0) * texture2D(u_diffuseTexture, v_texCoords);
    vec4 difusa = max(0.0,dot(normal,incidenciaLuz)) * u_dirLights0color * texture2D(u_diffuseTexture, v_texCoords);
    vec4 especular = pow(max(0.0, dot(visualizacao,reflexao)),5.0) * u_dirLights0color;

    especular *= 0.1;

    // Dá o resultado
    gl_FragColor = ambiente + difusa + especular;

    // DEBUG: para depurar, use a linha a seguir para definir a cor do fragmento
    //gl_FragColor = debugColor;
}
