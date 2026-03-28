# Simulator de Management al Memoriei (Assembly x86)

Acest proiect este un simulator simplificat de alocare și management al memoriei, scris în limbajul de asamblare x86 pe 32 de biți (sintaxa GNU AT&T). Acesta simulează modul în care un sistem de operare alocă, ține evidența și eliberează blocurile de memorie pentru diferite procese sau fișiere.

Proiectul conține două implementări distincte: un alocator de memorie unidimensional și un alocator de memorie bidimensional.

## 📂 Structura Proiectului

* `proiectasc_unidim.S`: Implementează un spațiu de memorie unidimensional cu o dimensiune totală de 1024 de blocuri. Include funcționalitatea de defragmentare.
* `proiectasc_bidim.S`: Implementează un spațiu de memorie bidimensional, structurat conceptual ca o matrice de 256 x 1024 (256 de linii, 1024 de blocuri per linie).

## ⚙️ Funcționalități și Operații

Programele citesc o secvență de operații de la intrarea standard (stdin). Prima valoare citită reprezintă numărul total de operații (`nroperatii`). Ulterior, fiecare operație este declanșată de un cod numeric:

### `1`: ADD
Alocă spațiu pentru unul sau mai multe fișiere/procese.
* **Date de intrare**: Numărul de fișiere `N`, urmat de `N` perechi de forma `(ID, Dimensiune)`.
* **Logica de alocare**: Dimensiunea cerută este împărțită la 8 pentru a determina numărul necesar de blocuri a câte 8 unități (rotunjind în sus dacă există rest). Programul caută în vectorul/matricea de memorie o secvență contiguă de zerouri suficient de mare pentru a stoca fișierul. 
* **Specific implementării 2D**: În versiunea bidimensională, secvența contiguă de blocuri trebuie să încapă integral pe o singură linie (rând) a matricei.
* **Ieșire**: Afișează coordonatele alocate.
    * *Format 1D*: `ID: (start, end)`
    * *Format 2D*: `ID: ((linie, start_col), (linie, end_col))`

### `2`: GET
Returnează intervalul de memorie alocat unui ID specific.
* **Date de intrare**: Descriptorul `ID`.
* **Ieșire**: Afișează coordonatele de început și sfârșit ale descriptorului. Dacă ID-ul nu este găsit în memorie, afișează `(0, 0)` pentru 1D sau `((0, 0), (0, 0))` pentru 2D.

### `3`: DELETE
Eliberează memoria asociată unui anumit ID, suprascriind blocurile acestuia cu zero.
* **Date de intrare**: Descriptorul `ID`.
* **Ieșire**: După finalizarea ștergerii, programul afișează starea curentă a memoriei (toate blocurile alocate și coordonatele lor).

### `4`: DEFRAGMENTATION (Doar pentru 1D)
Compactează memoria mutând toate blocurile alocate la începutul array-ului de memorie, eliminând astfel orice spații libere (zerouri) dintre ele.
* **Ieșire**: Afișează noua stare a memoriei după compactare.

## 🛠️ Compilare și Execuție

Aceste programe folosesc funcții din biblioteca standard C (`printf`, `scanf`, `fflush`), așadar trebuie linkate folosind `gcc` cu flag-urile necesare pentru arhitectura pe 32 de biți.

### Cerințe preliminare
Asigură-te că ai instalate pachetele `gcc` și bibliotecile de dezvoltare `libc` pentru 32 de biți. Pe sisteme Ubuntu/Debian, le poți instala rulând:
```bash
sudo apt-get install gcc-multilib
