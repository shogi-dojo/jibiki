# N5 Dictionary Entry Batch Processing Guide

This document outlines the efficient, reproducible workflow for generating Japanese-Ukrainian N5 dictionary entries in bulk. This guide is intended for AI agents taking over the task of expanding the dictionary.

## 1. Batch Sizing & Extraction
You can process multiple entries simultaneously. A batch size of **10 to 20 words** is optimal, but you should **identify the size of the batch by yourself** depending on your context window and processing limits. If 20 seems too heavy or you face context truncation, drop it down to 5 or 10.

1. **Over-extract source orders**: Because different N5 candidates may resolve to the same JMdict entry (e.g., variations of spelling), always extract a few more source orders than your target batch size. Use the batch task — it scans JMdict and Warodai **once** for the whole range (~15s total) instead of once per word (~10s each):
   ```bash
   # Example: To get 20 unique words, extract 25 source orders in one pass
   rake "sources:n5_batch[56,80]"
   ```
   (The single-order form `rake "sources:n5[56]"` still works but is ~15x slower per batch.)

2. **Identify unique JMdict entries**: Run a quick Python script to list the successfully extracted and unique JMdict entries.
   ```python
   # scratch/list_unique.py
   import json, glob
   unique_ids = set()
   for path in sorted(glob.glob('tmp/source-extracts/n5-*.json')):
       try:
           with open(path) as f:
               d = json.load(f)
               c = d['n5_candidate']['written'] or d['n5_candidate']['reading']
               o = d['n5_candidate']['source_order']
               jm = d['jmdict']['matches'][0]['ent_seq'] if d.get('jmdict',{}).get('matches') else 'NONE'
               if jm != 'NONE' and jm not in unique_ids:
                   unique_ids.add(jm)
                   print(f'Order {o}: {c} -> {jm}')
       except Exception as e:
           pass
   ```

## 2. Translation Preparation
Before writing the Org files, extract the English senses from the dossiers to provide accurate Ukrainian translations.
```bash
python3 -c "
import json
for o in range(56, 76):
    with open(f'tmp/source-extracts/n5-0000{o}.json') as f:
        d = json.load(f)
        jm = d['jmdict']['matches'][0] if d.get('jmdict',{}).get('matches') else None
        if not jm: continue
        print(f'=== Order {o}: {jm[\"ent_seq\"]} ===')
        for s in jm['senses']:
            gl = [g['text'] for g in s['glosses'] if g['lang']=='eng']
            if gl: print(f'Sense {s[\"index\"]}: {gl}')
"
```
Translate these senses and prepare a mapping dictionary in Python.

## 3. Automated Generation Script
Do not try to write the large `.org` files purely through terminal echoes or `sed`. Instead, write a python generator (e.g., `scratch/gen_n5.py`) that reads the source JSON, populates your translated Ukrainian glosses, and perfectly reconstructs the required schema.

**Key responsibilities of the generator**:
- Extract `jmdict_id` and `source_sha256` directly from the JSON.
- Reconstruct the `* Forms` and `* Sense` hierarchy precisely.
- Replicate the English glosses with exactly matching properties (e.g., `:PRIMARY: true/false`).
- Inject your custom Ukrainian glosses (`*** uk-s-...`) with your `TRANSLATOR_ID`.
- Handle Russian reference mapping (`ru-ref-` blocks) based on `sense_indexes_by_language['rus']`.

*(Note: Review previous generator scripts in the `scratch/` directory for the exact Python template.)*

## 4. Post-Processing & Cleanup
Python generators often leave trailing spaces (e.g., `- * `) or incorrect `#+ROMAJI:` headers which will cause the strict `org-lint` validation to fail. Run a fast cleanup script before validation:

```bash
python3 -c "
import glob
for path in glob.glob('entries/**/*.org', recursive=True):
    with open(path) as f: lines = f.readlines()
    romaji = path.split('-')[-1].split('.')[0]
    out = []
    for l in lines:
        l = l.rstrip()
        if l.startswith('#+ROMAJI:'): l = '#+ROMAJI: ' + romaji
        out.append(l)
    with open(path, 'w') as f:
        f.write('\n'.join(out) + '\n')
"
```

## 5. Validation and Commit
**Critical Rule**: You must validate and lint *every* file, and commit them individually.

```bash
# Define your newly generated files
files=(
  entries/xxxx/xxxxxxx-word1.org
  entries/yyyy/yyyyyyy-word2.org
)

# 1. Validate (parallel) and lint (all files in one Emacs process)
printf '%s\n' "${files[@]}" | xargs -P 8 -I{} ruby scripts/validate_entry.rb {} || exit 1
emacs --batch --eval '(progn (require (quote org)) (let ((failed nil)) (dolist (path command-line-args-left) (with-current-buffer (find-file-noselect path) (let ((issues (org-lint))) (when issues (princ (format "%s\n" path)) (prin1 issues) (princ "\n") (setq failed t))))) (kill-emacs (if failed 1 0))))' "${files[@]}" || exit 1

# 2. Commit individually
git add entries/xxxx/xxxxxxx-word1.org && git commit -m "feat: add word1 learner dictionary entry for 漢字"
git add entries/yyyy/yyyyyyy-word2.org && git commit -m "feat: add word2 learner dictionary entry for 漢字"
```

## 6. Handoff state
- Dictionary is at **151 entries**; the last completed batch covered source orders 137–156.
- **Next batch starts at source order 157**. Extracts for orders 157–170 are already in `tmp/source-extracts/`; extract further (e.g. `rake "sources:n5_batch[171,190]"`) to reach 20 unique words.
- Copy `scratch/gen_n5_part9.py` as the generator template (6-digit filename padding, correct for orders ≥100).
- Always dedupe new candidates against the `#+JMDICT_ID:` of existing entries before generating. Past collisions: orders 133/134 (下りる/降りる) share JMdict 1589500.
- Two entries may share a romaji filename stem legitimately (e.g. 風 and 風邪 are both `kaze`); they differ by JMdict ID, so paths do not collide.
- Sense counts vary wildly. 掛ける (1207610) has 25 senses and 掛かる (1207590) has 15, so a 20-word batch is not a fixed amount of work — size later batches by total senses, not word count.

## Reminders
- Only refer to **JMdict** as authoritative. **Warodai** is for private reference only and its definitions should not be copied or heavily paraphrased.
- Pay attention to `jmdict` senses: literally translate the literal meanings, and reserve figurative Ukrainian translations for the corresponding figurative JMdict senses.
- Verify for mixed cyrillic characters (like the Latin `i` instead of cyrillic `і`) manually or via script.
