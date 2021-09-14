#include "convolution.h"


void convolve(const float* image, float* output, std::size_t n, const float* mask, std::size_t m) {
	float sum;
	std::size_t xIndex;
	std::size_t yIndex;
	for (std::size_t x = 0; x < n; x++) {
		for (std::size_t y = 0; y < n; y++) {
			sum = 0.0;
			for (std::size_t i = 0; i < m; i++) {
				for (std::size_t j = 0; j < m; j++) {
					xIndex = x + i - (m - 1) / 2;
					yIndex = y + j - (m - 1) / 2;
					if (!(xIndex >= 0 && xIndex < n)) {
						if (!(yIndex >= 0 && yIndex < n)) {
							continue;
						}
						else {
							sum += mask[i * m + j];
							continue;
						}
					}
					else if (!(yIndex >= 0 && yIndex < n)) {
						sum += mask[i * m + j];
						continue;
					}
					sum += mask[i * m + j] * image[(x + i - (m - 1) / 2) * n + y + j - (m - 1) / 2];
				}
			}
			output[x * n + y] = sum;
		}
	}
}
