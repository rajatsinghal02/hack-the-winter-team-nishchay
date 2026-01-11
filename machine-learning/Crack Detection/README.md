# Crack Detection

**Overview:**

- This folder contains experiments and trained artifacts for automated crack detection using object detection models (Faster R-CNN, YOLO variants). The project includes model weights, converted exports, and training configuration used during development.

**Key contents**

- `FasterRCNN/` — Faster R-CNN checkpoint: `fasterrcnn_coco_checkpoint.pth`
- `YOLO11CrackDetection/` — YOLO-based experiments, calibration data, and `detect/` subfolders with multiple training runs.
- Inside training runs you'll find `results.csv`, `weights/` with model exports: `best.pt`, `best.onnx`, `last.pt`, and saved models / TFLite files under `best_saved_model/`.

Notebook & references

- Colab notebook used for experiments and walkthrough: https://colab.research.google.com/drive/12HJO58WRH4nliCJp1m3u-s19_MbXyW9L
- Research paper used for methodology and reference: see `RTIP2R2025_CRC_88.pdf` (project root).

Quick usage

1. Create a Python environment and install common packages (example):

```bash
python -m venv .venv
source .venv/bin/activate
pip install torch torchvision ultralytics onnxruntime tflite-runtime
```

2. Inspect available weights in the training run you want to use (e.g., `YOLO11CrackDetection/detect/train4/weights/`).

3. Run inference with a YOLO-style exported model (example using Ultralytics `yolo` CLI if `best.pt` is present):

```bash
# Replace with correct path to model and an input image or folder
yolo detect predict model=YOLO11CrackDetection/detect/train4/weights/best.pt source=sample_images/ save=True
```

Notes and pointers

- Several model formats are included (PyTorch `.pt`, ONNX `.onnx`, TensorFlow SavedModel, and TFLite). Use the appropriate runtime for each format (e.g., `onnxruntime` for ONNX, `tflite-runtime` for `.tflite`).
- For training details and hyperparameters, open the Colab notebook linked above and the run-specific `args.yaml` files in each `train*/` folder.

If you use or extend this work

- Cite the accompanying paper: `RTIP2R2025_CRC_88.pdf` (see project root).

Contact

- For questions about these experiments, add a note in the repo or message the project owner.
