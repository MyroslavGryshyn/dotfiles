# Project-specific aliases and functions — sourced from zshrc

lint-check() {
   python ./manage.py test server.tests.test_for_lint_errors
}

alias ssh-bn="ssh bn"

alias pg_start='pg_ctl start -D ~/Dev/postgres'

alias fe="workon fe"
alias be="workon backend"
alias backend="workon backend"
alias mmenv="workon mm"

# Personal Coach aliases
alias coach-log='tail -f ~/Dev/MM/logs/sync.log'
alias coach-errors='tail -f ~/Dev/MM/logs/errors.log'
alias coach-daily='tail -100 ~/Dev/MM/logs/daily.log'
alias coach-weekly='tail -50 ~/Dev/MM/logs/weekly.log'
alias coach-sync='cd ~/Dev/MM && python coach/sync_all.py'
alias coach-run='coach-sync'

# Master Mind CLI
unalias mm 2>/dev/null
function mm {
    case "$1" in
        run|start)
            cd ~/Dev/MM && PYTHONPATH=$PWD DAGSTER_HOME=~/.dagster dagster dev
            ;;
        status)
            pgrep -fl dagster && echo "\nDagster UI: http://127.0.0.1:3000" || echo "Dagster not running"
            ;;
        stop)
            pkill -f "dagster dev" && echo "Dagster stopped"
            ;;
        logs)
            tail -f ~/.dagster/logs/*.log 2>/dev/null || echo "No logs"
            ;;
        ui)
            open http://127.0.0.1:3000
            ;;
        search)
            shift
            cd ~/Dev/MM && PYTHONPATH=$PWD python -m embeddings.search "$@"
            ;;
        coach)
            shift
            cd ~/Dev/MM && PYTHONPATH=$PWD python -m coach.cli "$@"
            ;;
        ask)
            shift
            cd ~/Dev/MM && PYTHONPATH=$PWD python -m coach.cli "$@"
            ;;
        *)
            echo "Usage: mm {run|start|status|stop|logs|ui|search|coach|ask}"
            ;;
    esac
}

# Crypto arbitrage monitor
alias crypto-start="cd ~/Dev/crypto && pm2 start main.py --name crypto --interpreter python3"
alias crypto-stop="pm2 stop crypto"
alias crypto-logs="pm2 logs crypto"
