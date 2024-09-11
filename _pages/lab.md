---
title: "Lab"
permalink: /lab/
---

<style>
details > summary {
  list-style: none;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0px;
  font-weight: bold;
  font-size: 25px;
}
summary::after {
  content: '';
  width: 30px;
  height: 30px;
  background: url('/images/chevron-down-bold-nyu.svg') no-repeat;
  background-size: cover;
  transition: 0.2s;
}

details[open] > summary::after {
  transform: rotate(180deg);
}

summary::-webkit-details-marker {
  display: none;
}

summary {
  color: #56018D;
  border-radius: 5px;
}

details[open] summary {border-radius: 5px 5px 0 0;}

details {
  background-color: #FFFFFF;
  border-radius: 5px;
}
</style>

<p> <font color="#56018D"> <i class="fa fa-frog"></i></font> A collection of things I've been working on to help the understanding of statistics. </p>

<details>
  <summary>R Tutorials</summary>
  <ul>
    <li>
      UWO R Workshop 2024 
      <a href="/files/uwo/R_Workshop_2024.zip" class="btn--faicon">
        <i class="fa fa-cloud-arrow-down"></i>
      </a>
    </li>
  </ul>
</details>

<details>
  <summary>UWO Quant 1 — Labs</summary>
  <ul>
    <li>
      Lab 0
      <a href="/files/uwo/Quant1/quant1_Lab0.zip" download class="btn--faicon">
        <i class="fa fa-cloud-arrow-down"></i>
      </a>
    </li>
  </ul>
</details>

<details>
  <summary>Shiny Apps</summary>
  <ul>
    <li>
      Sample and Effect size influence on ATE 
      <a href="https://a4te44-william-poirier.shinyapps.io/Shiny/" class="btn--faicon">
        <i class="fa fa-rocket"></i>
      </a>
    </li>
  </ul>
</details>