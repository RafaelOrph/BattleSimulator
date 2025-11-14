import Foundation

let lootPossivel = ["Poção de Cura", "Poção de Mana", "Poção Grande", "Pocao de Energia"]
var inventario: [String: Int] = [:]
var turno: Bool = true
var classe : String = ""
inventario = ["Pocao de vida pequena": 3, "Pocao de vida media": 2, "Pocao de vida Grande" : 1, "Pocao de Energia" : 3 ]

var Enemys : [String: [String: Int]] = [
    "Esqueleto": ["HP": 20, "ATK": 12],
    "Slime": ["HP": 30, "ATK": 7],
    "Zumbi": ["HP": 55, "ATK": 10],
    "Aranha": ["HP": 30, "ATK": 6]
]

var Classes: [String : [String: [String: Int]]] = [
    "Guerreiro" : [
        "Golpe Dilacerante": ["DMG": 12, "MP": 6],
        "Vingança de Aço": ["DMG": 10, "MP": 4]],

    "Mago" : [
        "Bola de fogo": ["DMG": 15, "MP": 20],
        "Relampago impetuoso": ["DMG": 7, "MP": 3],
        "Flecha Glacial": ["DMG": 9, "MP": 4],
    ],

    "Arqueiro" : [
        "Tiro Certeiro": ["DMG": 13, "MP": 13],
        "Flecha Superior": ["DMG": 14, "MP": 19],
        "Foco de cacador": ["DMG": 6, "MP": 35]]
    ]

var plHP: Int! = 0
var plMP = 0
var atk = 0


enum ClassError: Error {
    case notValid
}

print("Bem Vindo ao Duelo - Escolha seu arquetipo")
print("1 - Guerreiro, 2 - Mago, 3 - Arqueiro")

var opcaoClasse = readLine() ?? ""

func selectClass(_ input: String) throws -> String {
    switch input {
    case "1", "Guerreiro":
        plHP = 50
        plMP = 20
        atk = 15
        return "Guerreiro"

    case "2", "Mago":
        plHP = 30
        plMP = 60
        atk = 9
        return "Mago"

    case "3", "Arqueiro":
        plHP = 42
        plMP = 37
        atk = 11
        return "Arqueiro"

    default:
        throw ClassError.notValid
    }
    
}

do {
    
    classe = try selectClass(opcaoClasse)
    print("Você escolheu: \(classe)")
    print("HP: \(plHP!)  MP: \(plMP)")
    
} catch {
    print("Classe inválida")
}

var defeatedEnemies: [String] = [] // Lista de inimigos derrotados

// Função que gera o próximo inimigo e elimina os já derrotados
func gerarInimigos() -> [String: [String: Int]] {
    // Filtra os inimigos que ainda não foram derrotados
    let remainingEnemies = Enemys.filter { !defeatedEnemies.contains($0.key) }
    
    // Se todos os inimigos foram derrotados, retorna uma mensagem de fim de jogo
    if remainingEnemies.isEmpty {
        print("Você derrotou todos os inimigos!")
        return [:]
    }
    
    // Escolhe um inimigo aleatório da lista de inimigos restantes
    let randomEnemy = remainingEnemies.randomElement()!
    
    // Adiciona o inimigo derrotado à lista de inimigos derrotados
    defeatedEnemies.append(randomEnemy.key)
    
    return [randomEnemy.key: randomEnemy.value]
}

// Função de batalha
func Battle(_ HP: inout Int, _ enemyHP: inout Int) {
    while HP > 0 && enemyHP > 0 {
        print("Qual a sua acao?")
        print(" 1 - atacar | 2 - usar habilidade | 3 - usar item | 4 - Fugir")
        
        var opcaoAcao = readLine() ?? ""
        
        switch opcaoAcao {
        case "1":
            enemyHP -= atk
        case "2":
            print("Qual habilidade deseja usar?")
            let (costHP, costMP) = usarHabilidade(classe)
            HP -= costHP
            plMP -= costMP
        case "3":
            print("Digite qual item quer usar")
            print(inventario)
            let item = readLine() ?? ""
            usarItem(item)
        case "4":
            print("Você fugiu do desafio da torre")
            return
        default:
            print("Ação inválida")
            continue
        }
        
        // Ataque do inimigo
        print("O inimigo te ataca!")
        HP -= Enemys["Esqueleto"]?["ATK"] ?? 0  // Adapte para usar o inimigo correto
        
        // Mostrar status
        print("Seus Status: HP \(HP), MP \(plMP)")
        print("Inimigo HP: \(enemyHP)")
    }
    
    if HP > 0 {
        print("Você Venceu a Batalha! \nAproveite suas recompensas")
        adicionarLootAleatorio()
    } else {
        print("Você foi derrotado!")
    }
    
    print(inventario)
}

// Ações de usar itens
func usarItem(_ item: String) {
    if let quantidade = inventario[item], quantidade > 0 {
        inventario[item] = quantidade - 1
        print("Você usou \(item). Agora possui \(inventario[item] ?? 0)")

        if inventario[item] == 0 {
            inventario.removeValue(forKey: item)
        }
    } else {
        print("Você não possui \(item).")
    }
    switch item {
    case "Pocao de vida pequena":
        plHP += 5
    case "Pocao de vida media":
        plHP += 10
    case "Pocao de vida Grande":
        plHP += 16
    case "Pocao de Energia":
        plMP += 6
    default:
        print("Item não escolhido")
    }
}

// Usar habilidade
func usarHabilidade(_ Classe: String) -> (Int, Int) {
    print("Qual habilidade deseja usar?")
    let habilidades = Classes[Classe]?.keys
    print(habilidades ?? [])
    
    let opcao = readLine() ?? ""
    if let habilidade = Classes[Classe]?[opcao], let damage = habilidade["DMG"], let mpCost = habilidade["MP"] {
        plMP -= mpCost
        return (damage, mpCost)
    }
    
    print("Habilidade inválida.")
    return (0, 0)
}

// Loot Aleatório
func adicionarLootAleatorio() {
    let item = lootPossivel.randomElement()!
    inventario[item, default: 0] += 1
    
    print("Você ganhou: \(item)")
    
    print("\nInventário:")
}

let randomEnemy = gerarInimigos()
if !randomEnemy.isEmpty {
    let nomeInimigo = randomEnemy.keys.first!
    var enemyHP = randomEnemy[nomeInimigo]?["HP"] ?? 0

    print("\nInimigo encontrado: \(nomeInimigo)\n")
    print("Inimigo HP: \(enemyHP)")

    Battle(&plHP, &enemyHP)

} else {
    print("Todos os inimigos foram derrotados! Fim de jogo.")
}

