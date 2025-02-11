shader_type canvas_item;

// Cor da fumaça
uniform vec4 smoke_color = vec4(1.0, 1.0, 1.0, 1.0);  // Cor padrão branca
// Densidade das nuvens
uniform float density: hint_range(0.0, 1.0) = 0.25;
// Velocidade de distorção
uniform float distortion_speed: hint_range(0.0, 5.0, 0.1) = 0.5;
// Velocidade de movimento das nuvens
uniform vec2 speed = vec2(0.02, 0.01);
// Quantidade de nuvens
uniform int cloud_count: hint_range(1, 10) = 3;

// Função de ruído Perlin aprimorado
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Interpolações suaves usando a função `smoothstep` embutida
    vec2 u = smoothstep(vec2(0.0), vec2(1.0), f);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void fragment() {
    vec2 uv = UV * 4.0;
    float cloud = 0.0;

    // Gerar múltiplas nuvens baseadas em posições aleatórias
    for (int i = 0; i < cloud_count; i++) {
        vec2 random_offset = vec2(random(vec2(float(i))), random(vec2(float(i + 1))));
        vec2 uv_offset = uv + random_offset * 10.0 + speed * TIME;
        float n = noise(uv_offset);
        cloud += clamp(n * 2.0 - 1.0, 0.0, 1.0) * density;
    }

    cloud = clamp(cloud, 0.0, 1.0);

    // Cor das nuvens
    vec4 color = smoke_color * cloud;

    // Aplica a cor das nuvens ao fragmento
    COLOR = color;
    COLOR.a *= cloud;
}
