package unstructured

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

#Unstructured: {
    metav1.#TypeMeta

	metadata?: metav1.#ObjectMeta

	...
}
