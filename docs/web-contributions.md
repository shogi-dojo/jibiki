# Web contributions

The Jibiki website (`jibiki.japan-dojo.com`) lets signed-in Japan Dojo members
propose edits to the Ukrainian and enrichment layer of an entry. Moderators
approve or reject each proposal on the site. Approved proposals come back to this
repository as bot pull requests, so the Org files here stay the dictionary's
source of truth.

## What can be edited

Only the authored layer (docs/org-format.md §16): Ukrainian glosses, learner
notes, examples and collocations can be added, edited, removed or confirmed, and
a whole entry can be deleted. Forms, readings, English glosses, Russian
references, indexes and fingerprints come from JMdict and are never edited from
the site.

## How an edit reaches a file

`OrgEntry::Patch` (`lib/org_entry/patch.rb`) applies a proposal to the entry's
text line by line. It finds each block by its stable ID and rewrites only that
block's lines, so comments, wrapping and the rest of the file are untouched.
Every edit carries the values its author saw. If the file has changed since,
the patch raises a conflict instead of overwriting the change, and a moderator
updates the proposal.

New blocks take the next free number for their sense (§17). The patcher only
sees the current file, so it cannot avoid an ID that was deleted earlier at the
end of the range.

`EntryValidator.validate_text` checks the patched text before the bot commits
it. The `Contributions` workflow then validates the changed files against the
pinned JMdict archive.

## Contributor IDs and review

Site contributors appear in drawers as `dojo:<handle>`. A handle is chosen once,
on the first edit, and never changes.

- An approved edit or addition records its author as `TRANSLATOR_ID` (glosses)
  or `AUTHOR_ID` (enrichments), and the approving moderator as `REVIEWER_ID`, so
  the block becomes `reviewed`. A moderator's own proposal needs another
  moderator, because nobody reviews their own text (§8.4).
- A confirmation records the confirming member as `REVIEWER_ID` on an existing
  block. Nobody can confirm their own translation.
- Enrichment drawers may carry `REVIEWER_ID` and `REVIEWED_AT` as well (§9).
- `ENTRY_STATUS` becomes `reviewed` once every Ukrainian gloss in the entry is
  reviewed. Any later unreviewed edit makes it `draft` again. `#+UPDATED_AT`
  records the date of the last change.

## Bot pull requests

The site opens at most one pull request a day, from a `contrib/<date>` branch,
with one commit per approved proposal:

```
contrib(ao): add a gloss for sense 1

Contributed-by: dojo:olena
Reviewed-by: dojo:taras
Proposal: https://jibiki.japan-dojo.com/proposals/123
```

The site merges the PR with a merge commit (keeping one commit per proposal)
once the `Contributions` check passes, then rebuilds its search data from
`main`. Edits made here, by people or agents, reach the site through the same
rebuild.
