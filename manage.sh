#!/bin/bash

# Output colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if .env exists
if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        cp .env.example .env
        echo -e "${GREEN}.env file created from .env.example${NC}"
    else
        echo "OLLAMA_PORT=11434" > .env
        echo "OLLAMA_DATA_DIR=ollama_data" >> .env
        echo "OLLAMA_KEEP_ALIVE=5m" >> .env
        echo -e "${YELLOW}.env.example not found. Created .env with default settings.${NC}"
    fi
fi

source .env

while true; do
    echo -e "\n${GREEN}--- Claude Code + Ollama Manager ---${NC}"
    echo "1) Start Ollama"
    echo "2) Stop Ollama and clear RAM/VRAM (Stop & Down)"
    echo "3) Check Status"
    echo "4) View Logs"
    echo "5) List Available Models"
    echo "6) Run Model"
    echo "7) FULL REMOVAL (Containers and Data)"
    echo "0) Exit"
    echo "------------------------------------"
    read -p "Select an option: " choice

    case $choice in
        1)
            echo -e "${GREEN}Starting container...${NC}"
            mkdir -p "$OLLAMA_DATA_DIR"
            docker compose up -d
            echo -e "${GREEN}Done! Ollama is available on port $OLLAMA_PORT${NC}"
            ;;
        2)
            echo -e "${RED}Stopping and unloading from memory...${NC}"
            docker compose down
            ;;
        3)
            docker compose ps
            ;;
        4)
            docker compose logs -f --tail=50
            ;;
        5)
            echo -e "${GREEN}List of available models:${NC}"
            docker compose exec ollama ollama list
            ;;
        6)
            echo -e "${GREEN}Select a model to run:${NC}"
            echo "1) gemma4:31b-cloud"
            echo "2) glm-5.1:cloud"
            echo "3) qwen3-coder-next:cloud"
            echo "4) qwen3-next:80b-cloud"
            echo "5) qwen3.5:cloud"
            read -p "Your choice: " model_choice
            case $model_choice in
                1) MODEL="gemma4:31b-cloud" ;;
                2) MODEL="glm-5.1:cloud" ;;
                3) MODEL="qwen3-coder-next:cloud" ;;
                4) MODEL="qwen3-next:80b-cloud" ;;
                5) MODEL="qwen3.5:cloud" ;;
                *) echo -e "${RED}Invalid choice.${NC}"; MODEL="" ;;
            esac
            if [ -n "$MODEL" ]; then
                echo -e "${GREEN}Running model $MODEL...${NC}"
                docker compose exec ollama ollama run "$MODEL"
            fi
            ;;
        7)
            echo -e "${RED}WARNING: This will delete all settings and downloaded models!${NC}"
            read -p "Are you sure? (y/n): " confirm
            if [ "$confirm" == "y" ]; then
                docker compose down -v
                rm -rf "$OLLAMA_DATA_DIR"
                echo -e "${RED}Everything deleted.${NC}"
            fi
            ;;
        0)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice. Please try again.${NC}"
            ;;
    esac
done