# Instrukcja obsługi Git LFS w repozytorium

## Spis treści
1. [Instalacja Git LFS](#instalacja-git-lfs)  
2. [Konfiguracja LFS w repozytorium](#konfiguracja-lfs-w-repozytorium)  
3. [Dodawanie istniejących plików do LFS](#dodawanie-istniejących-plików-do-lfs)  
4. [Deinstalacja LFS i przywracanie plików](#deinstalacja-lfs-i-przywracanie-plików)  
5. [Przykłady użycia](#przykłady-użycia)  

<div style="margin:1em 0 0 0;text-align:center;font-size:3em">°°°</div>

## Instalacja Git LFS

### Wymagania:

- Git (min. wersja 1.8.2)  
- Konto na GitHub (dla synchronizacji)  

### Kroki:

1. Pobierz i zainstaluj Git LFS:  

   **Linux (Debian/Ubuntu):**  

   ```bash
   curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
   sudo apt-get install git-lfs
   ```

   **Windows/macOS:**  

   Pobierz instalator z [oficjalnej strony Git LFS](https://git-lfs.github.com/).  

2. Aktywuj LFS w systemie:  

   ```bash
   git lfs install
   ```
   
   UWAGA: *Dla konkretnego repozytorium:* `git lfs install --local`

## Konfiguracja LFS w repozytorium

1. Przejdź do katalogu repozytorium:  
   
   ```bash
   cd ścieżka/do/repozytorium
   ```

2. Śledź wybrane rozszerzenia plików (np. PDF):  

   ```bash
   git lfs track "*.pdf"
   git lfs track "*.psd"
   ```

3. Dodaj plik `.gitattributes` do repozytorium:  

   ```bash
   git add .gitattributes
   git commit -m "Dodaj Git LFS do śledzenia plików"
   ```

## Dodawanie istniejących plików do LFS

Jeśli repozytorium już zawiera pliki, które chcesz przenieść do LFS:

1. Usuń pliki z historii Gita (bez fizycznego usuwania):  

   ```bash
   git rm --cached *.pdf
   ```

2. Dodaj je ponownie, aby LFS je przechwycił:  

   ```bash
   git add *.pdf
   git commit -m "Przenoszę istniejące pliki PDF do LFS"
   ```

3. Wypchnij zmiany na GitHub:  

   ```bash
   git push origin gh-pages --force
   ```

   UWAGA: `--force` *nadpisuje historię, upewnij się, że współpracownicy są świadomi!*  


## Deinstalacja LFS i przywracanie plików

### A. Przywracanie plików do standardowego Gita

1. Usuń śledzenie plików w LFS:  

   ```bash
   git lfs untrack "*.pdf"
   ```

2. Usuń pliki z LFS (fizycznie pozostają na dysku):  

   ```bash
   git rm --cached *.pdf
   git add *.pdf
   git commit -m "Przywracam pliki PDF do standardowego Gita"
   ```

3. Zaktualizuj `.gitattributes`:  

   ```bash
   git add .gitattributes
   git commit -m "Usuwam reguły LFS"
   ```

### B. Całkowita deinstalacja LFS

1. Usuń konfigurację LFS:  

   ```bash
   git lfs uninstall
   ```

2. Usuń plik `.gitattributes` (opcjonalne):  

   ```bash
   rm .gitattributes
   git commit -am "Usuwam .gitattributes"
   ```

## Przykłady użycia

- **Dodawanie nowego pliku PDF przez LFS:**  

  ```bash
  git lfs track "nowy.pdf"
  git add nowy.pdf
  git commit -m "Dodaj nowy PDF przez LFS"
  git push origin gh-pages
  ```

- **Sprawdzenie stanu LFS:**  

  ```bash
  git lfs ls-files
  ```

## Konfiguracja Git LFS w różnych branchach

### Czy `.gitattributes` musi być w każdym branchu?

**Nie**, ale **zalecane jest** utrzymywanie spójnej konfiguracji LFS we wszystkich branchach, gdzie pracujesz z dużymi plikami.

### Co się dzieje gdy branch nie ma `.gitattributes`?

| Scenariusz | Skutek |
|-----------|--------|
| Nowy branch utworzony z brancha zawierającego `.gitattributes` | Konfiguracja LFS zostanie zachowana |
| Branch utworzony przed dodaniem LFS | Brak automatycznego śledzenia plików |
| Ręczne usunięcie `.gitattributes` w branchu | Git przestanie używać LFS dla nowych plików |

### Jak zapewnić spójność LFS?

1. **Dodaj `.gitattributes` do nowych branchy**:

   ```bash
   git checkout nowy-branch
   git checkout main -- .gitattributes
   git commit -m "Dodaj konfigurację LFS"
   ```

2. **Napraw brakujące konfiguracje w istniejących branchach**:
   
   ```bash
   # Dla każdego brancha wykonaj:
   git checkout nazwa-brancha
   if [ ! -f .gitattributes ]; then
     git checkout main -- .gitattributes
     git commit -m "Dodaj brakujący .gitattributes dla LFS"
   fi
   ```

3. **Sprawdź konfigurację**:
   
   ```bash
   git lfs ls-files  # Wyświetla pliki śledzone przez LFS
   ```

### Uwagi specjalne

- **Merge branchy**: Przy scalaniu branchy bez `.gitattributes` mogą wystąpić konflikty z plikami LFS
- **Force push**: Po dodaniu LFS do istniejącego brancha rozważ `--force-with-lease` jeśli historia została zmieniona
- **Hooki Git**: Możesz dodać pre-commit hook sprawdzający obecność `.gitattributes`

   ```bash
   #!/bin/sh
   # Przykładowy hook .git/hooks/pre-commit
   if [ ! -f .gitattributes ]; then
       echo "UWAGA: Brak pliku .gitattributes - LFS może nie działać poprawnie!"
       exit 1
   fi
   ```

**Zalecenie**: Utrzymuj identyczną konfigurację LFS we wszystkich aktywnych branchach projektu.

## Uwagi
- GitHub ma limit **1 GB LFS** dla darmowych repozytoriów.  
- Pliki w LFS są liczone osobno w limicie rozmiaru repozytorium.  
- W przypadku problemów z dostępem do plików na GitHub Pages sprawdź, czy repozytorium jest **publiczne**.  

<div style="margin:30px 0 0;border-bottom:1px solid lightGray;">&nbsp;</div>
EOF — `Instrukcja obsługi Git LFS.md` w katalogu dokumentacji projektu. 
