"""
参考文献
https://muuumin.net/julia_wonderful_ecosystem/

# 多重ディスパッチ (Multiple dispatch)
引数の型だけ違う同じ名前の関数で定義され、その引数の型にあった関数が実行される仕組みのこと。
```
struct
  Type
end
```
という構文で型を定義できる。
Juliaではメソッドはデータ構造からは独立しているので、構造体の外部に定義される。

# 例題
ポケモンのダメージ計算を例に考える。簡単のため、以下のような仕様にする。
* ポケモンは炎、草、水のタイプに分類される。
* ポケモンは炎、草、水タイプの技が使える。
* ポケモンは技タイプによって受けるダメージに補正がかかる（相性係数）。
  * 炎タイプの技は草タイプのポケモンに対して2倍のダメージ補正がある。
  * 草タイプの技は水タイプのポケモンに対して2倍のダメージ補正がある。
  * 水タイプの技は炎タイプのポケモンに対して2倍のダメージ補正がある。
* ポケモンのタイプと技のタイプが一致していると、1.5倍のダメージ補正がある（タイプ一致係数）。
* ダメージ計算は以下で与えられる。
  * ダメージ = 攻撃ポケモンのレベル * 技の威力 * 相性係数 * タイプ一致係数
"""

abstract type Pokemon end

struct FirePokemon <: Pokemon
  level
end

struct GrassPokemon <: Pokemon
  level
end

struct WaterPokemon <: Pokemon
  level
end


abstract type Skill end

struct FireSkill <: Skill
  power
end

struct GrassSkill <: Skill
  power
end

struct WaterSkill <: Skill
  power
end


function main()
  defence = FireInvinciblePokemon(10)
  attack = WaterPokemon(10)
  attack_skill = WaterSkill(6)

  damage = calc_damage(defence, attack, attack_skill)
  println("Invincible pokemon got a damage $(damage)!")
end


function calc_damage(defence, attack, attack_skill)
  damage = attack.level * attack_skill.power * effectivity_ratio(defence, attack_skill) * type_ratio(attack, attack_skill)
  return damage
end


function effectivity_ratio(defence::Pokemon, skill::Skill)
  return 1.0
end

function effectivity_ratio(defence::FirePokemon, skill::FireSkill)
  return 0.5
end

function effectivity_ratio(defence::FirePokemon, skill::WaterSkill)
  return 2.0
end

function effectivity_ratio(defence::WaterPokemon, skill::WaterSkill)
  return 0.5
end

function effectivity_ratio(defence::WaterPokemon, skill::GrassSkill)
  return 2.0
end

function effectivity_ratio(defence::GrassPokemon, skill::GrassSkill)
  return 0.5
end

function effectivity_ratio(defence::GrassPokemon, skill::FireSkill)
  return 2.0
end

function type_ratio(attack::Pokemon, skill::Skill)
  return 1.0
end

function type_ratio(attack::FirePokemon, skill::FireSkill)
  return 1.5
end

function type_ratio(attack::WaterPokemon, skill::WaterSkill)
  return 1.5
end

function type_ratio(attack::GrassPokemon, skill::GrassSkill)
  return 1.5
end

# 仕様の変更 1
# 固定ダメージ技の追加
# 相性などに関わらず一定のダメージを与える技を実装する。

abstract type FixedDamageSkill <: Skill end

struct FixedDamageFireSkill <: FixedDamageSkill
  power
end

struct FixedDamageWaterSkill <: FixedDamageSkill
  power
end

struct FixedDamageGrassSkill <: FixedDamageSkill
  power
end

# 以下を実装するだけで、上のコードを変更しなくて良い
# というのが多重ディスパッチのメリット
function calc_damage(defence, attack, attack_skill::FixedDamageSkill)
  return attack_skill.power
end

# 仕様の変更 2
# どんな攻撃を受けてもダメージをゼロにする
# 無敵ポケモンの実装
abstract type InvinciblePokemon <: Pokemon end

struct FireInvinciblePokemon <: InvinciblePokemon
  level
end

struct WaterInvinciblePokemon <: InvinciblePokemon
  level
end

struct GrassInvinciblePokemon <: InvinciblePokemon
  level
end

function calc_damage(defence::InvinciblePokemon, attack, attack_skill::Skill)
  return 0
end

main()
