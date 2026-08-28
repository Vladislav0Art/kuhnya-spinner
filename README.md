# kuhnya-spinner

Спиннер Claude Code («Diggling…») говорит цитатами из «Кухни».

```bash
./apply.sh max,shef   # оба набора
```

```bash
./apply.sh max        # только закадровые мудрости Макса
./apply.sh shef       # только шеф и бригада
```

Пишет `spinnerVerbs` в `~/.claude/settings.json`, старый файл сохраняет в
`settings.json.bak.<дата>`. Перезапуск не нужен — подхватится на следующем ходу.

```bash
./apply.sh --show     # что стоит сейчас
./apply.sh --restore  # откат
./preview.sh          # прокрутить фразы, как их покажет спиннер
```
