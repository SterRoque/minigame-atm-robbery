# ATM Robbery

![ATM Robbery](https://imgur.com/a/A5hbRkw)

Este recurso para **FiveM** implementa um sistema de **roubo a caixas eletrônicos (ATM)** para servidores QBCore. O jogador usa um **C4** para arrombar o ATM, completa um minigame, explode o caixa e coleta o dinheiro em **notas marcadas**. A estrutura do projeto é organizada em três partes principais: `server`, `client` e `ui`, cada uma responsável por uma camada da aplicação.

[Vídeo de demonstração](https://medal.tv/games/gta-v/clips/n3xLC3SsadjLxwnER?invite=cr-MSx6WHIsNTMxMzE3MzA5&v=95)

## Fluxo

1. Chegue perto de um ATM e aperte **G**
2. Precisa ter o item **C4** (validado no server)
3. Complete o minigame de sequência de teclas
4. Animação de plantar a C4 → **15s** → explosão
5. Volte ao ATM e aperte **E**
6. Coleta com progressbar (**20s**) → recebe as notas marcadas
7. O ATM entra em **cooldown**

## Dependências

- `qb-core`
- `progressbar`
- `qb-inventory` (item `markedbills`)

## Instalação

1. Coloque a pasta em `resources/[cfx-default]/[local]/`
2. Se alterar a UI, rebuild:
   ```bash
   cd ui && npm install && npm run build
   ```

## Item necessário

O item `c4` precisa estar registrado no `qb-core/shared/items.lua`. Se não existir, adicione:

```lua
c4 = { name = 'c4', label = 'C4', weight = 1000, type = 'item', image = 'weapon_proxmine.png', unique = true, useable = true, shouldClose = false, description = 'C4 explosiva' },
```

> A recompensa usa o item `markedbills`, que já vem por padrão no QBCore.

## Configuração

Tudo em [`shared/config.lua`](shared/config.lua):

| Opção                                     | Descrição                   |
| ----------------------------------------- | --------------------------- |
| `Config.RequiredItem`                     | Item necessário (`c4`)      |
| `Config.ExplosionDelay`                   | Tempo até explodir (ms)     |
| `Config.CollectDuration`                  | Duração da coleta (ms)      |
| `Config.Cooldown`                         | Cooldown por ATM (ms)       |
| `Config.Reward`                           | Valor mín/máx da recompensa |
| `Config.PlantAnim` / `Config.CollectAnim` | Animações                   |
| `Config.Locations`                        | Coordenadas dos ATMs        |

## Estrutura

```
minigame-atm-robbery/
├── shared/config.lua    # configurações
├── client/main.lua      # interação, minigame, explosão, coleta
├── server/main.lua      # validação, item, pagamento, cooldown
└── ui/                  # minigame (React + Tailwind)
```

Feito por **Ster Roque**.
