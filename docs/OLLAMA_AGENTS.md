# 🤖 Project Checkpoint: Local LLM Inference Architecture (Ollama + Tailscale)

## 📌 Contexto & Objetivo
Estruturar o PC Principal como um servidor privado de inferência de IA, disponibilizando a GPU dedicada e o serviço do Ollama para o Laptop/Notebook via rede mesh criptografada, sem duplicar modelos e garantindo reprodutibilidade no Arch Linux.

---

## 🏗️ Decisões Arquiteturais

### 1. Armazenamento dos Modelos (PC Principal)
* **Estratégia Escolhida:** Partição Linux Dedicada (`ext4` / `btrfs`) de ~128 GB no SSD Interno.
* **Justificativa:** Evita gargalos de I/O de drivers NTFS no Linux, remove o risco de desconexões de SSD externo e isola o ecossistema do Windows.
* **Política de Modelos (Gestão de Espaço ~128 GB):**
  1. **Heavy Model:** 1x Modelo de alta capacidade (34B–70B quantizado) para tarefas complexas.
  2. **Daily Driver:** 1x Modelo médio (8B–14B) rápido para uso geral.
  3. **Inline Completion:** 1x Modelo ultra-light (1B–3B) dedicado a autocompletar em editores de código.
* **Opção de Fallback:** SSD Externo de 128 GB (apenas como última alternativa).

### 2. Ambientes & Execution Host
* **Host do Servidor:** Arch Linux Nativo no PC Principal (Dual-boot).
* **Decisão:** WSL2 descartado devido à complexidade de rede e Overhead de GPU. O Arch Linux entrega acesso direto aos drivers de vídeo e automação limpa via `systemd`.

### 3. Camada de Rede & Acesso Remoto
* **Tecnologia:** Tailscale (VPN Mesh Privada via WireGuard).
* **Justificativa:** Dispensa *port-forwarding* no roteador, atribui IP estático/MagicDNS e criptografa o tráfego de ponta a ponta de forma simples e transparente.
* **Fluxo de Trabalho:** O notebook consulta o servidor apontando a variável de ambiente `OLLAMA_HOST` diretamente para o IP/Name do PC Principal na rede Tailscale.

---

## 🛠️ Próxima Etapa do Planejamento
1. Definir o script/fluxo de criação e montagem da partição dedicada para o Ollama.
2. Criar a `systemd` user/system unit do Ollama configurada com `OLLAMA_MODELS` e `OLLAMA_HOST=0.0.0.0:11434`.
3. Validar a conexão no notebook via Tailscale.