# kuhnya-spinner

Спиннер Claude Code («Diggling…») говорит цитатами из «Кухни».

```bash
./apply.sh max,shef   # оба набора
```

```bash
./apply.sh max        # только закадровые мудрости Макса
./apply.sh shef       # только шеф и бригада
```

`apply.sh` пишет ключ `spinnerVerbs` в `~/.claude/settings.json`, старый файл
сохраняет рядом как `settings.json.bak.<дата>`. Перезапускать Claude Code не
нужно — настройка подхватится на следующем ходу.

Нужен Claude Code **2.1.23 или новее** (`claude --version`) — в более старых
версиях ключа `spinnerVerbs` ещё нет, и он просто игнорируется: спиннер
останется со стандартными «Diggling…».

```bash
./apply.sh --show     # что стоит сейчас
./apply.sh --restore  # откат
./preview.sh          # прокрутить фразы, как их покажет спиннер
```
