### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 46f59f50-7d41-11eb-28e1-8fc4afcc6837
using Optim

# ╔═╡ c60c577a-7d41-11eb-2390-79a7c6acb0d0
f(x) = (1.0 - x[1]) ^2 + 100.0  * (x[2] - x[1]^2)^2

# ╔═╡ 028dbf9a-7d42-11eb-218b-657847801c0f
x0 = [0.0 0.0]

# ╔═╡ 0b11dd5e-7d42-11eb-15e9-bde4ac3d7662
optimize(f, x0)

# ╔═╡ 24734878-7d42-11eb-10e7-35421889faaf


# ╔═╡ 167d66f2-7d42-11eb-1967-3fff5fa301dd


# ╔═╡ 11e7141e-7d42-11eb-2d63-7155e958f07d


# ╔═╡ Cell order:
# ╠═46f59f50-7d41-11eb-28e1-8fc4afcc6837
# ╠═c60c577a-7d41-11eb-2390-79a7c6acb0d0
# ╠═028dbf9a-7d42-11eb-218b-657847801c0f
# ╠═0b11dd5e-7d42-11eb-15e9-bde4ac3d7662
# ╠═24734878-7d42-11eb-10e7-35421889faaf
# ╠═167d66f2-7d42-11eb-1967-3fff5fa301dd
# ╠═11e7141e-7d42-11eb-2d63-7155e958f07d
