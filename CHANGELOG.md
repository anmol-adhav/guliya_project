# Changelog

## [0.1.0] - 2026-04-06

### Added
- Initial pipeline: gene calling → Phold annotation → dark fraction extraction
- MMseqs2 clustering at 90% identity
- Length filter for ESMFold input (≤ 1000 aa)
- ESMFold structure prediction script with resume support
- pLDDT quality filter and IDP candidate separation
- Foldseek novel fold screening against PDB, AFDB50, and SCOP
- Conda environment YAML files for all tools
- README with full pipeline documentation and quick start guide
