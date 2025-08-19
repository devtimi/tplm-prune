# TPLM Backup Prune Tool

A Xojo Console application to prune redundant TPLM backups.

TPLM performs backups after 24 hours have passed since the previous backup and a "significant value" has been changed. This can cause backups as frequently as every day. After months and years of usage, these backups can pile up.

While the TPLM Web Panel offers a purge tool, this console application automates a more sophisticated pruning:

- Backups older than 4 weeks are limited to one per month
- Backups older than 12 months are limited to one per year

The prune tool will retain the last backup within the relevant window of time.


## Example usage:

Execute the `tplm-prune` executable without a parameter to operate on the default backups location. Optionally pass `tplm-prune` a path for the backups location if you are not using the default.

```
tplm-prune /path/to/.com.strawberrysw.licensemanager/backups
```

<small>(with optional parameter)</small>

## Automate with Lifeboat

The prune tool can be [automated as cron job](https://strawberrysw.com/lifeboat/manual/tools/cron/index.html) with [Lifeboat](https://strawberrysw.com/lifeboat).

1. Upload `tplm-prune` as a Web App, but stop the service
2. Copy the path for `tplm-prune` from the Live Files list using the contextual-click menu
3. Navigate to `Server Tools > Cron Jobs` and select the desired time interval
4. Click the `[ + ]` at the bottom to create a new script and name it
5. Edit the script and paste the executable path as its own line
6. Save and done!