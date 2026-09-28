<h1 align="center">🤖 RoboWorld 2026 Track 2: HA-VLN<br>Human-Aware Vision-and-Language Navigation</h1>

<div align="center" markdown="1">

**Official participant toolkit for RoboWorld 2026 Track 2**

*Built on [HA-VLN 2.0](https://uwmilab.github.io/HA-VLN-webpage/) and co-organized with the [RoboPAD Workshop at NeurIPS 2026](https://robotpad2026.github.io/)*

[![RoboWorld](https://img.shields.io/badge/RoboWorld-2026-blue)](https://roboworld2026.github.io/)
[![Track 2](https://img.shields.io/badge/Track_2-HA--VLN-green)](https://f1y1113.github.io/havln-challenge/)
[![CodaBench](https://img.shields.io/badge/CodaBench-Submit-purple)](https://www.codabench.org/competitions/18135/)
[![RoboPAD](https://img.shields.io/badge/Jointly_with-RoboPAD_2026-red)](https://robotpad2026.github.io/)
[![Paper](https://img.shields.io/badge/arXiv-2503.14229-b31b1b)](https://arxiv.org/abs/2503.14229)

**🏆 Prize Pool: $2,800 (1st: $1,500 · 2nd: $800 · 3rd: $500) + certificates; Rising Star Award**

<img src="assets/media/teaser.webp" alt="HA-VLN task overview" width="82%" />

</div>

## 🌍 Challenge Overview

HA-VLN evaluates instruction-following agents in continuous indoor environments
populated by dynamic people. An agent must ground a natural-language route,
reach its goal, and avoid human collisions. Official scoring replays submitted
actions in the released HA-VLN 2.0 Habitat 0.1.7 runtime.

### 🎯 Task Definition

| Component | Description |
|:--|:--|
| Input | Episode ID, initial position and yaw, navigation instruction, and released human-aware episode inputs. |
| Output | One sequence made from six discrete VLN-CE actions. |
| Actions | `STOP`, `MOVE_FORWARD`, `TURN_LEFT`, `TURN_RIGHT`, `LOOK_UP`, `LOOK_DOWN`. |
| Budget | 1–500 actions; all six actions count toward the limit. |
| Evaluation | Trusted simulator replay measuring navigation and human-aware safety. |

`LOOK_UP` and `LOOK_DOWN` are legal pitch-changing actions from VLN-CE. They do
not move the agent and have no binding to human animation frames.

## 📅 Competition Details

- **Event:** RoboWorld Challenge 2026, Track 2.
- **Associated workshop:** [RoboPAD Workshop at NeurIPS 2026](https://robotpad2026.github.io/).
- **Registration:** register through [RoboWorld 2026](https://roboworld2026.github.io/) to be eligible for the leaderboard and awards.
- **Submission platform:** [CodaBench — HA-VLN](https://www.codabench.org/competitions/18135/).
- **Submission limits:** five per day and 100 per phase; the best score is retained.

### 🗓️ Timeline

| Event | Date |
|:--|:--|
| Phase 1 opens | September 30, 2026, 16:00 UTC |
| Phase 1 deadline | October 31, 2026, 15:59 UTC |
| Phase 2 opens | November 2026; exact time to be confirmed |
| Phase 2 deadline | November 20, 2026; exact time to be confirmed |
| Awards | December 2026 |

Follow the [competition page](https://www.codabench.org/competitions/18135/) for any schedule updates.

### 🗂️ Phases

| Phase | Submission | Leaderboard role |
|:--|:--|:--|
| Phase 1 | Released `val_seen` and `val_unseen` action sequences | Reports both splits; ranks by full-precision `val_unseen` Score. |
| Phase 2 | Action sequences for the held-out phase bundle | Determines final ranking and awards. |

Both phases use the same six-action JSON contract and Score. Phase 1 and Phase
2 results are not combined.

### 🏆 Awards

| Place | Award |
|:--|:--|
| 🥇 1st | $1,500 USD + certificate |
| 🥈 2nd | $800 USD + certificate |
| 🥉 3rd | $500 USD + certificate |

The [RoboWorld Rising Star Award](https://roboworld2026.github.io/) is also available; see the event site for eligibility and details.

## 📊 Dataset

The challenge uses released HA-VLN 2.0 resources: HA-R2R navigation episodes
and instructions, HAPS2.0 human assets, multi-human annotations, and licensed
Matterport3D scenes. Challenge datasets are external to the Docker image.

| HA-R2R split | Distinct trajectories | Episodes / instructions | Human-influenced episodes ($\beta L$) |
|:--|--:|--:|--:|
| Train | 3,603 | 10,819 | — |
| `val_seen` | 259 | 778 | 682 |
| `val_unseen` | 613 | 1,839 | 1,593 |

Distinct trajectories are counted by `trajectory_id` within each released
split; each episode requires its own action sequence.

Phase 1 requires one action sequence for each of the 778 `val_seen` and 1,839
`val_unseen` episodes. The complete HA-R2R benchmark contains 16,844
instructions across 90 scenes. Its HAPS2.0 assets comprise 910 placed human
models drawn from 486 motion sequences of 120 frames each. Final-phase episode
identities and submission coverage will be supplied with that phase's bundle.

```text
/data/havln2/
├── HA-R2R/
│   ├── val_seen/val_seen_bertidx.json.gz
│   └── val_unseen/val_unseen_bertidx.json.gz
├── HA-R2R-tools/
│   ├── collision_num_val_seen.json
│   └── collision_num_val_unseen.json
├── Multi-Human-Annotations/human_motion.json
├── HAPS2_0/<released-human-assets>
├── scene_datasets/mp3d/<licensed-scene-assets>
├── ddppo-models/<released-encoder-weights>.pth  # optional for CMA
└── recompute_navmesh/                 # writable replay cache
```

To obtain Matterport3D, visit the [official dataset page](https://niessner.github.io/Matterport/),
sign its [Terms of Use](https://kaldir.vc.in.tum.de/matterport/MP_TOS.pdf), and send
the signed form to `matterport3d@googlegroups.com` to request access. Once
approved, obtain the official `download_mp.py` script and follow the
[HA-VLN 2.0 VLN-CE scene instructions](https://github.com/UWMILab/HA-VLN/blob/main/agent/VLN-CE/README.md#scenes-matterport3d)
to download the Habitat scene assets:

```bash
python2 download_mp.py --task habitat -o /absolute/path/to/havln2-data/scene_datasets/mp3d/
```

The resulting layout must include
`<host-data-root>/scene_datasets/mp3d/<scan>/<scan>.glb`. Your host data root
can be anywhere. When using the challenge Docker image, mount it at
`/data/havln2` and run `havln-check-data`.
Matterport3D is not included in this repository, helper script, image, or
submission kit.

## 🚀 Getting Started

### 1. Download released public data

The helper requires an explicit destination. It downloads the public HA-R2R and
HAPS2.0 packages plus the released validation collision baselines and human
motion annotations from [HA-VLN 2.0](https://github.com/UWMILab/HA-VLN).
Install `gdown` in your Python environment and have `unzip` and `curl`
available before running:

```bash
bash scripts/download_data.sh --destination /absolute/path/to/havln2-data
```

Add the separately licensed Matterport3D scenes as described above. For CMA or
another baseline using a pretrained depth encoder, download the optional
[DD-PPO weights](https://dl.fbaipublicfiles.com/habitat/data/baselines/v1/ddppo/ddppo-models.zip)
to `ddppo-models/` following the [upstream instructions](https://github.com/UWMILab/HA-VLN#-download-dataset).
`havln-check-data` checks replay data and scenes, not these optional weights.
The required replay-data layout is shown in the Dataset section above.

### 2. Run a baseline and export actions

You may use any agent. For a concrete starting point, set up the released
[HA-VLN 2.0 CMA baseline](https://github.com/UWMILab/HA-VLN) and follow the
[CMA action-export hook](#cma-action-export-hook) below. Its original inference
file contains positions, not the discrete actions required here. Record the
actions as CMA takes them; do not infer actions from the saved positions.
After adding the export hook, run inference for each public split from
the upstream `agent/` directory:

```bash
python run.py --exp-config config/cma_pm_da_aug_tune.yaml --run-type inference \
  INFERENCE.SPLIT val_seen
python run.py --exp-config config/cma_pm_da_aug_tune.yaml --run-type inference \
  INFERENCE.SPLIT val_unseen
```

The hook writes `val_seen.json` and `val_unseen.json` with `format_version: 1`,
official episode IDs, and the actions actually executed. The released CMA
checkpoint may use only the four planar actions; these remain valid members of
the challenge's six-action vocabulary.

### 3. Package and check the submission

Download the Phase 1 Starting Kit from [CodaBench](https://www.codabench.org/competitions/18135/) and extract it. Its STOP-only
sample provides every required episode ID and illustrates the schema; replace
its actions with your predictions. From the extracted kit directory, run the
standard-library checker without Docker:

```bash
python3 check_submission.py sample_submission.zip
PRED_DIR=/absolute/path/to/your-predictions
zip -j submission.zip "$PRED_DIR/val_seen.json" "$PRED_DIR/val_unseen.json"
python3 check_submission.py submission.zip
```

The checker verifies format and exact episode coverage, but computes no Score.
Upload that validated ZIP to CodaBench. For optional local simulator replay,
use the immutable public image reference in the
[Local Docker Replay](#-local-docker-replay) section below. Participant code can live anywhere;
only the image's data mount uses `/data/havln2`.

### CMA action-export hook

The upstream `BaseILTrainer.inference()` writes position paths, not the
discrete actions required for a submission. In your own HA-VLN checkout, edit
`agent/VLN-CE/vlnce_baselines/common/base_il_trainer.py`. Immediately after
`episode_predictions = defaultdict(list)`, add:

```python
action_traces = defaultdict(list)
action_names = tuple(config.TASK_CONFIG.TASK.POSSIBLE_ACTIONS)
```

Replace `outputs = envs.step([a[0].item() for a in actions])` with:

```python
step_actions = [int(a[0].item()) for a in actions]
for episode, action_id in zip(current_episodes, step_actions):
    action_traces[str(episode.episode_id)].append(action_names[action_id])
outputs = envs.step(step_actions)
```

Immediately after `envs.close()`, export the trace:

```python
split = config.INFERENCE.SPLIT
with open(f"{split}.json", "w", encoding="utf-8") as handle:
    json.dump(
        {
            "format_version": 1,
            "split": split,
            "episodes": [
                {"episode_id": episode_id, "actions": action_traces[episode_id]}
                for episode_id in sorted(action_traces)
            ],
        },
        handle,
        indent=2,
    )
```

The source already imports `json` and `defaultdict`. Record the action before
each `envs.step` call; do not reconstruct turns or looks from saved positions.
The configured action order is the action-index order used by the policy.
The released four-action CMA checkpoint need not be expanded to six actions:
its action vocabulary is a valid subset of the challenge vocabulary.

## 🐳 Local Docker Replay

The public runtime image is optional for participants. It contains the
HA-VLN 2.0 / Habitat 0.1.7 replay environment, but no challenge data or
licensed Matterport3D scenes. The immutable image reference is:

```text
ghcr.io/jostarxiong/havln-challenge-2026@sha256:e1a0544f66beaf5218cc9df63da51b4a1a22a6bf0471ca0c2f75e81ee02a6556
```

The historical package name is only an image identifier; it does not impose
a location for your own code. Install Docker and NVIDIA Container Toolkit
for GPU replay. Validation and environment checks do not need a GPU:

```bash
IMAGE=ghcr.io/jostarxiong/havln-challenge-2026@sha256:e1a0544f66beaf5218cc9df63da51b4a1a22a6bf0471ca0c2f75e81ee02a6556
DATA_ROOT=/absolute/path/to/havln2-data
NAVMESH_ROOT=/absolute/path/to/writable-navmesh-cache
WORK_ROOT=/absolute/path/to/participant-workspace

docker pull "$IMAGE"
docker run --rm "$IMAGE" havln-check-environment
docker run --rm \
  -v "$DATA_ROOT:/data/havln2:ro" \
  -v "$NAVMESH_ROOT:/data/havln2/recompute_navmesh" \
  "$IMAGE" havln-check-data
docker run --rm -v "$WORK_ROOT:/workspace" "$IMAGE" \
  havln-validate /workspace/submission.zip
```

For optional complete Phase 1 replay, expose the GPUs selected on your host.
The `--gpu-ids` values are GPU ordinals as seen *inside* the container:

```bash
docker run --rm --gpus '"device=0,1"' \
  -v "$DATA_ROOT:/data/havln2:ro" \
  -v "$NAVMESH_ROOT:/data/havln2/recompute_navmesh" \
  -v "$WORK_ROOT:/workspace" \
  "$IMAGE" havln-score-phase1 \
  --submission /workspace/submission.zip \
  --output-dir /workspace/results \
  --gpu-ids 0 1
```

Local replay may generate navmeshes in the separately writable cache mount.
Participant code may live anywhere and may be mounted read-only at any path;
there is no required launcher or agent directory. Local results help with
development, but only CodaBench's official replay determines leaderboard
scores.

## 🧠 Baseline Model

CMA is the released VLN-CE cross-modal attention reference adapted by HA-VLN
2.0. The paper also evaluates HA-VLN-VL, BEVBert and ETPNav as comparison
methods; CMA is the executable challenge reference, not a required architecture.

| Model | Role | Main approach |
|:--|:--|:--|
| HA-VLN-CMA | Challenge reference | Cross-modal attention over instruction and observations. |
| HA-VLN-VL | Paper comparison | Vision-language navigation baseline adapted to human-aware scenes. |
| BEVBert | Paper comparison | Bird's-eye-view language-conditioned navigation. |
| ETPNav | Paper comparison | Topological navigation with exploration and planning. |

Organizer re-evaluation of the public CMA validation checkpoint produced:

| Split | SR ↑ | NE ↓ | CR ↓ | TCR ↓ | Score ↑ |
|:--|--:|--:|--:|--:|--:|
| `val_seen` | 0.165 | 6.230 | 0.638 | 13.271 | 15.469585 |
| `val_unseen` | 0.114 | 6.502 | 0.689 | 22.352 | 11.944822 |

Score is calculated from unrounded metrics; the displayed component metrics are
rounded. Values may differ slightly from other reported CMA runs because of
checkpoint, runtime, or evaluation details.

## 📏 Evaluation

| Metric | Direction | Meaning |
|:--|:--|:--|
| SR | Higher | Collision-free success rate over all episodes. |
| NE | Lower | Mean final navigation error in metres. |
| CR | Lower | Collision-episode rate over released human-influenced episodes. |
| TCR | Lower | Mean adjusted human-collision count over all episodes. |

Let $L$ be the number of episodes, $s_i$ the navigation-success indicator,
$d_i$ the final goal distance, and $e_i$ the adjusted human-collision count.
The released human-influenced episode count is $\beta L$:

$$
\begin{aligned}
\mathrm{SR} &= \frac{1}{L}\sum_{i=1}^{L}s_i\mathbf{1}[e_i=0], &
\mathrm{NE} &= \frac{1}{L}\sum_{i=1}^{L}d_i, \\
\mathrm{CR} &= \frac{\sum_{i=1}^{L}\min(e_i,1)}{\beta L}, &
\mathrm{TCR} &= \frac{1}{L}\sum_{i=1}^{L}e_i.
\end{aligned}
$$

In particular, CR divides by the released human-influenced episode count
$\beta L$, while SR, NE, and TCR divide by all $L$ episodes.

### 🏁 Composite Score

The composite Score uses the full-precision metrics (higher is better):

$$
\begin{aligned}
\mathrm{Navigation} &= 0.80 \times \mathrm{SR} + 0.20 \times \frac{3}{3 + \mathrm{NE}}, \\
\mathrm{Social} &= 0.75 \times (1 - \mathrm{CR}) + 0.25 \times \frac{1}{1 + \mathrm{TCR}}, \\
\mathrm{Score} &= 100 \times \mathrm{Navigation} \times (0.70 + 0.30 \times \mathrm{Social}).
\end{aligned}
$$

Higher Score ranks first. Exact ties use higher SR, lower NE, lower CR, lower
TCR, then earlier submission time. Calculation and comparison retain full
precision.

## 📥 Submission Format

Phase 1 requires one valid prediction JSON for each validation split. The
following ZIP is the recommended layout, not a filename restriction:

```text
submission.zip
├── val_seen.json
└── val_unseen.json
```

Each file follows this schema (the invented ID is only an illustration):

```json
{
  "format_version": 1,
  "split": "val_unseen",
  "episodes": [
    {
      "episode_id": "synthetic-example-001",
      "actions": ["MOVE_FORWARD", "TURN_LEFT", "LOOK_UP", "LOOK_DOWN", "STOP"]
    }
  ]
}
```

Include every official episode ID exactly once. `STOP`, if present, occurs once
at the end; sequences shorter than 500 actions require it. The examples in
[`examples/submission`](examples/submission) demonstrate schema only and do not
have complete manifest coverage.

The validator identifies predictions by each JSON object's `split` value, so
you may rename the files and include harmless extra root files. It rejects
missing or duplicate required splits, invalid prediction content, unsafe ZIP
members, and nested paths. Phase 2 follows the same rule with its single
required `test` split when that phase opens.

## ❓ Frequently Asked Questions

**Q1. Must I use CMA or a particular architecture?**

No. Any method is eligible if it exports legal official action sequences.

**Q2. Do I submit code, weights, or a container?**

For CodaBench scoring, submit only the required JSON action-sequence files in
one ZIP; no code, weights, or container are part of that upload. However, if
your team earns an award, you will be expected to contribute to a technical
report explaining your method and innovations, including relevant model,
training, and implementation details. Organizers may request code or model
information to verify an awarded result.

**Q3. Are `LOOK_UP` and `LOOK_DOWN` valid?**

Yes. Both are original VLN-CE pitch actions and count toward 500 task steps.

**Q4. Does an action advance a human animation frame?**

No. Human animation follows released wall-clock behavior independently.

**Q5. Does local validation compute a Score?**

`havln-validate` checks structure and coverage only. Local replay can compute
metrics for development, but only the official replay result published on
CodaBench for the submitted archive determines leaderboard scores and awards.
Results from another machine are not accepted as official scores.

**Q6. Why did my ZIP fail validation?**

`SUBMISSION REJECTED:` means the ZIP needs correction: check for a parent
folder, missing or duplicate split, duplicate/missing episode IDs (778
`val_seen` and 1,839 `val_unseen` are required), invalid action names, or
incorrect `STOP` placement. `PASS:` means validation or replay succeeded.
`SCORING DATA ERROR (organizer):` indicates a scoring-side problem; report
the submission identifier rather than changing valid predictions.

**Q7. Can the image download Matterport3D for me?**

No. Request access through the [Matterport3D dataset page](https://niessner.github.io/Matterport/):
sign its Terms of Use and email the form to `matterport3d@googlegroups.com`.
After approval, use the [HA-VLN 2.0 VLN-CE scene guide](https://github.com/UWMILab/HA-VLN/blob/main/agent/VLN-CE/README.md#scenes-matterport3d),
and place the licensed scenes under your host data root's
`scene_datasets/mp3d/`. That root can be anywhere on your machine. When using
the challenge Docker image, mount it at `/data/havln2` inside the container.

## 🔗 Contact and Resources

For technical support, use [GitHub Issues](https://github.com/F1y1113/havln-challenge/issues).
For event and registration questions, email
[roboworld2026@outlook.com](mailto:roboworld2026@outlook.com). The consolidated
challenge dataset distribution will be linked when available.

| Resource | Link |
|:--|:--|
| RoboWorld 2026 | [Challenge website](https://roboworld2026.github.io/) |
| Starting kits, submissions, and leaderboard | [CodaBench](https://www.codabench.org/competitions/18135/) |
| Track website | [HA-VLN Challenge](https://f1y1113.github.io/havln-challenge/) |
| Challenge repository and participant toolkit | [GitHub](https://github.com/F1y1113/havln-challenge) |
| Associated workshop | [RoboPAD 2026](https://robotpad2026.github.io/) |
| HA-VLN 2.0 | [Project page](https://uwmilab.github.io/HA-VLN-webpage/) |
| HA-VLN 2.0 code and CMA | [Official repository](https://github.com/UWMILab/HA-VLN) |
| VLN-CE | [Original repository](https://github.com/jacobkrantz/VLN-CE) |
| Challenge rules and submission details | [CodaBench](https://www.codabench.org/competitions/18135/) and this README |
| HA-VLN 2.0 Get Started | [Project documentation](https://jostarxiong.github.io/havln2-docs/) |

## 📄 License and Terms

HA-VLN 2.0, HA-R2R, HAPS2.0, pretrained weights, and source assets retain their upstream
licenses. Matterport3D requires separate authorized access. Participation is
governed by the Terms displayed on the official CodaBench competition.

## 📚 Citation

If you use HA-VLN 2.0 or this challenge toolkit, cite the benchmark paper:

```bibtex
@misc{dong2025havln20openbenchmark,
  title={HA-VLN 2.0: An Open Benchmark and Leaderboard for Human-Aware Navigation in Discrete and Continuous Environments with Dynamic Multi-Human Interactions},
  author={Yifei Dong and Fengyi Wu and Qi He and Zhi-Qi Cheng and Heng Li and Minghan Li and Zebang Cheng and Yuxuan Zhou and Jingdong Sun and Qi Dai and Alexander G. Hauptmann},
  year={2025},
  eprint={2503.14229},
  archivePrefix={arXiv},
  primaryClass={cs.AI},
  url={https://arxiv.org/abs/2503.14229}
}

@misc{roboworld2026track2,
  title={Track 2 | HA-VLN: Human-Aware Vision-and-Language Navigation},
  author={RoboWorld Challenge 2026 Organizers},
  year={2026},
  howpublished={https://f1y1113.github.io/havln-challenge/}
}
```

## 🤝 Acknowledgements

The track is organized by the RoboWorld Challenge 2026 team and jointly held
with RoboPAD 2026. We thank the HA-VLN 2.0 and VLN-CE authors, dataset and
simulator contributors, Matterport3D, and CodaBench.
