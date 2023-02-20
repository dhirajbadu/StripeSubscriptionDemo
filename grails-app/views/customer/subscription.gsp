<%@ page import="stripedemo.SubscriptionType" contentType="text/html;charset=UTF-8" %>
<asset:stylesheet src="main.css"/>
<asset:stylesheet src="bootstrap.min1.css"/>
<asset:stylesheet src="all-min.css"/>
<asset:stylesheet src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"/>
<!DOCTYPE html>
<html>
<head>
    <title>Buy cool new product</title>
    <link rel="stylesheet" href="style.css">
    <meta name="layout" content="main"/>
    <script src="https://js.stripe.com/v3/"></script>
</head>

<body>
<section class="pricing py-5">
    <div class="container">
        <div class="row">
        <!-- Basic Subscription -->
            <g:each in="${basicSubscription}" var="subscription">
                <div class="col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <form action="/customer/selectSubscriptionPlan" method="POST">
                                <input type="hidden" name="id" , value="${customer?.getId()}">
                                <input type="hidden" name="name" ,
                                       value="${subscription?.getTitle()} Plan/${subscription?.getPlanType()}">
                                <input type="hidden" name="description" ,
                                       value="${subscription?.getTitle()} Plan/${subscription?.getPlanType()} Description">
                                <input type="hidden" name="amount" , value="${subscription?.getRate()}">
                                <input type="hidden" name="plan" , value="${subscription?.getPlanType()}">
                                <input type="hidden" name="planName" , value="${subscription?.getTitle()}">
                                <h5 class="card-title text-muted text-uppercase text-center">${subscription?.getTitle()}</h5>
                                <h6 class="card-price text-center">$${subscription?.getRate()}<span
                                        class="period">/${subscription?.getPlanType()}</span></h6>
                                <hr>
                                <ul class="fa-ul">
                                    <li><span class="fa-li"><i class="fas fa-check"></i>
                                    </span><strong>Unlimited Users</strong>
                                    </li>
                                    <li><span class="fa-li"><i class="fas fa-check"></i></span>150GB Storage</li>
                                    <li><span class="fa-li"><i class="fas fa-check"></i></span>Unlimited Public Projects
                                    </li>
                                    <li><span class="fa-li"><i class="fas fa-check"></i></span>Community Access</li>
                                    <li><span class="fa-li"><i class="fas fa-check"></i>
                                    </span>Unlimited Private Projects
                                    </li>
                                    <li><span class="fa-li"><i class="fas fa-check"></i></span>Dedicated Phone Support
                                    </li>
                                    <li><span class="fa-li"><i class="fas fa-check"></i>
                                    </span><strong>Unlimited</strong> Free
                                    Subdomains</li>
                                    <li><span class="fa-li"><i class="fas fa-check"></i></span>Monthly Status Reports
                                    </li>
                                </ul>

                                <g:if test="${subscription?.getTitle().equals(customer?.currentSubscription) && subscription?.getPlanType().equals(customer?.currentSubscriptionType)}">
                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-secondary text-uppercase"
                                                disabled>Subscribed</button>
                                    </div>
                                </g:if>
                                <g:else>
                                    <div class="d-grid">
                                        <button type="submit"
                                                class="btn btn-primary text-uppercase">Subscription</button>
                                    </div>
                                </g:else>
                            </form>
                        </div>
                    </div>
                </div>
            </g:each>
        %{--premium subscription--}%
            <g:each in="${premiumSubscription}" var="subscription">
                <div class="col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <form action="/customer/selectSubscriptionPlan" method="POST">
                                <input type="hidden" name="id" , value="${customer?.getId()}">
                                <input type="hidden" name="name" ,
                                       value="${subscription.getTitle()} Plan/${subscription.getPlanType()}">
                                <input type="hidden" name="description" ,
                                       value="${subscription.getTitle()} Plan/${subscription.getPlanType()} Description">
                                <input type="hidden" name="amount" , value="${subscription.getRate()}">
                                <input type="hidden" name="plan" , value="${subscription.getPlanType()}">
                                <input type="hidden" name="planName" , value="${subscription.getTitle()}">
                                <h5 class="card-title text-muted text-uppercase text-center">${subscription.getTitle()}</h5>
                                <h6 class="card-price text-center">$${subscription.getRate()}<span
                                        class="period">/${subscription.getPlanType()}</span></h6>
                                <hr>
                                <ul class="fa-ul">
                                    <li><span class="fa-li"><i class="fas fa-check"></i>
                                    </span><strong>Unlimited Users</strong>
                                    </li>
                                    <li><span class="fa-li"><i class="fas fa-check"></i></span>150GB Storage</li>
                                    <li><span class="fa-li"><i class="fas fa-check"></i></span>Unlimited Public Projects
                                    </li>
                                    <li><span class="fa-li"><i class="fas fa-check"></i></span>Community Access</li>
                                    <li><span class="fa-li"><i class="fas fa-check"></i>
                                    </span>Unlimited Private Projects
                                    </li>
                                    <li><span class="fa-li"><i class="fas fa-check"></i></span>Dedicated Phone Support
                                    </li>
                                    <li><span class="fa-li"><i class="fas fa-check"></i>
                                    </span><strong>Unlimited</strong> Free
                                    Subdomains</li>
                                    <li><span class="fa-li"><i class="fas fa-check"></i></span>Monthly Status Reports
                                    </li>
                                </ul>
                                <g:if test="${subscription?.getTitle().equals(customer?.currentSubscription) && subscription?.getPlanType().equals(customer?.currentSubscriptionType)}">
                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-secondary text-uppercase"
                                                disabled>Subscribed</button>
                                    </div>
                                </g:if>
                                <g:else>
                                    <div class="d-grid">
                                        <button type="submit"
                                                class="btn btn-primary text-uppercase">Subscription</button>
                                    </div>
                                </g:else>
                            </form>
                        </div>
                    </div>
                </div>
            </g:each>
        </div>
    </div>
</section>
</body>
</html>