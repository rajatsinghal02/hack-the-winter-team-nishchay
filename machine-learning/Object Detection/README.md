# Object Detection

**Overview:**

- This folder contains resources for object detection experiments focused on underwater object detection. The primary dataset and inspiration come from a Roboflow dataset and related research (see links below).

Dataset & model link

- Roboflow Universe dataset used as a reference: https://universe.roboflow.com/objectdetectioncustomdataset/underwater-object-detection-7pfax
- Research paper used as a reference and methodology guide: `Underwater_Object_Detection_paper_IEEE.pdf` (project root).

Suggested workflow

1. Download/export the Roboflow dataset in the format you prefer (COCO / YOLO) and place it in this folder or a `data/` subfolder.
2. Train using your chosen framework. Example with Ultralytics YOLOv8:

```bash
pip install ultralytics
# Example training command (adjust paths and hyperparameters)
yolo detect train model=yolov8n.pt data=data/underwater_yaml.yaml epochs=50 imgsz=640
```

3. After training, export weights and convert to desired formats (ONNX, TFLite) for deployment and inference.

Notes and recommendations

- Use augmentation and domain-specific preprocessing for underwater imagery (color correction, contrast adjustment, denoising).
- Evaluate on held-out validation images and review predicted samples in `predicted_test_samples/` if present.
- If you want to reproduce experiments from the attached paper, consult `Underwater_Object_Detection_paper_IEEE.pdf` in the project root.

References

- Roboflow dataset page: https://universe.roboflow.com/objectdetectioncustomdataset/underwater-object-detection-7pfax
- Paper: `Underwater_Object_Detection_paper_IEEE.pdf` (project root).
