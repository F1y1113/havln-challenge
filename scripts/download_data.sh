#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 --destination DESTINATION [--dry-run]" >&2
  echo "Downloads public HA-R2R, HAPS2.0, and validation auxiliary files." >&2
  echo "Matterport3D is licensed separately and is not downloaded." >&2
}

destination=""
dry_run=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --destination)
      [[ $# -ge 2 ]] || { usage; exit 2; }
      destination=$2
      shift 2
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage
      exit 2
      ;;
  esac
done

[[ -n "$destination" ]] || { usage; exit 2; }

haps_id="1gNdA4_mDAhW6g6Yedq2ypOR1N1sFpARB"
har2r_id="1_-5StHsRP6REKrANMxKIscPtEP7sx-q0"
source_revision="f46f93642d7ab96cc49611f8cfea09cecf2fa7f9"
source_base="https://raw.githubusercontent.com/UWMILab/HA-VLN/$source_revision/Data"
ddppo_url="https://dl.fbaipublicfiles.com/habitat/data/baselines/v1/ddppo/ddppo-models.zip"

echo "Destination: $destination"
echo "HAPS2_0.zip <- Google Drive file $haps_id"
echo "HAR2R-CE.zip <- Google Drive file $har2r_id"
echo "Validation collision baselines and human_motion.json <- HA-VLN 2.0 public source"
echo "Matterport3D is not downloaded; obtain it from the official source under its license."
echo "Optional CMA depth weights are not downloaded: $ddppo_url"

if [[ $dry_run -eq 1 ]]; then
  exit 0
fi

command -v gdown >/dev/null || {
  echo "gdown is required. Install it in your own Python environment." >&2
  exit 3
}
command -v unzip >/dev/null || {
  echo "unzip is required." >&2
  exit 3
}
command -v curl >/dev/null || {
  echo "curl is required to retrieve released validation annotations." >&2
  exit 3
}

mkdir -p "$destination/downloads" "$destination/HAPS2_0" "$destination/HA-R2R"

download_and_extract() {
  local file_id=$1
  local archive_name=$2
  local extract_dir=$3
  local archive_path="$destination/downloads/$archive_name"
  if [[ ! -s "$archive_path" ]]; then
    gdown "https://drive.google.com/uc?id=$file_id" -O "$archive_path"
  fi
  unzip -q -n "$archive_path" -d "$destination/$extract_dir"
}

download_and_extract "$haps_id" HAPS2_0.zip HAPS2_0

# The released archive wraps the model directories in this historical folder.
# Flatten it without overwriting an existing model from an earlier download.
haps_wrapper="$destination/HAPS2_0/human_motion_glbs_v3"
if [[ -d "$haps_wrapper" ]]; then
  shopt -s dotglob nullglob
  haps_entries=("$haps_wrapper"/*)
  for source_path in "${haps_entries[@]}"; do
    target_path="$destination/HAPS2_0/${source_path##*/}"
    if [[ -e "$target_path" || -L "$target_path" ]]; then
      echo "Refusing to overwrite existing HAPS2.0 entry: $target_path" >&2
      exit 4
    fi
    mv "$source_path" "$target_path"
  done
  rmdir "$haps_wrapper"
fi

download_and_extract "$har2r_id" HAR2R-CE.zip HA-R2R

download_public_file() {
  local source_relative=$1
  local target_relative=$2
  local target="$destination/$target_relative"
  local partial
  if [[ -s "$target" ]]; then
    echo "Already present: $target"
    return
  fi
  mkdir -p "${target%/*}"
  partial=$(mktemp "${target}.partial.XXXXXX")
  if ! curl --fail --location --retry 3 --output "$partial" "$source_base/$source_relative"; then
    rm -f "$partial"
    echo "Failed to download released file: $source_relative" >&2
    return 1
  fi
  if [[ ! -s "$partial" ]]; then
    rm -f "$partial"
    echo "Empty released file: $source_relative" >&2
    return 1
  fi
  mv "$partial" "$target"
}

download_public_file HA-R2R-tools/collision_num_val_seen.json \
  HA-R2R-tools/collision_num_val_seen.json
download_public_file HA-R2R-tools/collision_num_val_unseen.json \
  HA-R2R-tools/collision_num_val_unseen.json
download_public_file Multi-Human-Annotations/human_motion.json \
  Multi-Human-Annotations/human_motion.json

echo "Public validation data extracted. Add licensed scenes, then run havln-check-data."
echo "CMA users can obtain optional depth weights from: $ddppo_url"
